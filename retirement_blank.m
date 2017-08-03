clr;

% all in pre-tax dollars

%% inputs

% retirement_age = 50;
RoR = 0.03; % rate of return minus inflation
retirement_RoR = 0.02; % rate of return of your retirement funds during retirement
retirement_income = 100000; % desired yearly income during retirement
side_income_after_retirement = 0; %after retirement, only until ss kicks in

% firm inputs
current_age = 30;
lifespan = 95;
ss_age = 67;
% ira_post_to_pre = 1/0.8;
% tsp_post_to_pre = 1/0.8;
current_tsp = 50000;
current_ira = 50000;
monthly_to_tsp = (18000)/12; % household dollars to TSP/401k
monthly_to_ira = (5500 + 5500)/12; %household dollars to IRA
high_3 = 100000; % high 3 salary, to calculate govt annuity
ssa_total = 12*2000+12*2000; % yearly social security estimate
% ssa_total = 08
% ira_post_to_pre = 1/0.9;
% tsp_pos_to_pre = 1/0.9;


for retirement_age = [current_age:1:lifespan];
%     for retirement_age = retirement_age
    %% sim
    tsp(current_age-1) = current_tsp;
    ira(current_age-1) = current_ira;
    r = RoR;
    r_retire = retirement_RoR;
    n = 12;
    t = 1;
    PMT = monthly_to_tsp;
    PMTira = monthly_to_ira;
    life = [current_age:1:lifespan];
    
    for age = life
        tsp_factor(age-1) = tsp(age-1)/(tsp(age-1)+ira(age-1));
        %     tsp_factor(age-1) = 1;
        % calculate ss
        if age>= 67
            ssa(age) = ssa_total;
        else
            ssa(age) = 0;
        end
        
        % calculate pension
        if age>= 62
            pension(age) = high_3 * 0.01 * (retirement_age-23);
        else
            pension(age) = 0;
        end
        
        % calculate side income
        if age >= retirement_age
            if age <= ss_age
                side_income(age) = side_income_after_retirement;
            else
                side_income(age) = 0;
            end
        else
            side_income(age) = 0;
        end
        
        
        
        % calculate how much i need to take out of retirement accounts
        if age>=retirement_age
            if (retirement_income - ssa(age) - pension(age))>0
                withdrawl(age) = retirement_income - ssa(age) - pension(age) - side_income(age);
            else
                withdrawl(age) = 0;
            end
        else
            withdrawl(age)=0;
        end
        
        % calculate tsp
        Ptsp=tsp(age-1);
        if age<=retirement_age
            tsp(age)=(Ptsp*(1+r/n)^(n*t) + PMT * (((1 + r/n)^(n*t) - 1) / (r/n)) * (1+r/n));
        else
            tsp(age) = (Ptsp*(1+r_retire/n)^(n*t)) - withdrawl(age)*tsp_factor(age-1);
        end
        
        % calculate roth ira
        Pira=ira(age-1);
        if age<=retirement_age
            ira(age)=(Pira*(1+r/n)^(n*t) + PMTira * (((1 + r/n)^(n*t) - 1) / (r/n)) * (1+r/n));
        else
            ira(age) = (Pira*(1+r_retire/n)^(n*t)) - withdrawl(age)*(1-tsp_factor(age-1));
        end
        
        
        
        %     withdrawl(age) = retirement_income - ssa(age) - pension(age);
        
    end
    
    successful_retirement(retirement_age) = ira(lifespan) >0 | tsp(lifespan) > 0;
    
end
niceplot(life,tsp(current_age:end)./1000000,'Age','Assets (M)','TSP Assets','h',1,'s','b');
niceplot(life,ira(current_age:end)./1000000,'Age','Assets (M)','TSP Assets','h',1,'s','k');
niceplot(life,withdrawl(current_age:end)./1000000,'Age','Assets (M)','TSP Assets','h',1,'s','r');
niceplot([retirement_age retirement_age],[0 2],'Age','Assets (M)','Retirement Projection','h',1,'s','r--');
legend({'TSP Assets','IRA Assets','Withdrawl from Accounts','Retirement'})
niceplot([1:1:lifespan],successful_retirement,'Age at Retirement','Did you have money then?','When Can I Retire?');
successful_retirement_age=find(successful_retirement==1,1,'first')



