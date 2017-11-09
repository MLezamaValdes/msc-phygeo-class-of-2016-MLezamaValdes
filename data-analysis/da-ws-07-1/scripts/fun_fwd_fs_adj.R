# dm-ws-07-1
# MOC - Data Analysis (T. Nauss, C. Reudenbach)
# Multiple linear regression, forward feature selection
# Forward feature selection function -------------------------------------------
forward_feature_selection <- function(data, dep, vars, selected_vars = NULL){
  fwd_fs <- lapply(seq(length(vars)), function(v){
    if(is.null(selected_vars)){
      formula <- paste(dep, " ~ ", paste(vars[v], collapse=" + "))#paste: was kommt dazwischen, erster Teil mit Tilde, hinten mit +
    } else {
      formula <- paste(dep, " ~ ", paste(c(selected_vars, vars[v]), collapse=" + "))
    }
    
    lmod <- lm(formula, data = data)#um sich den Zugriff auf columns zu sparen
    results <- data.frame(Variable = vars[v],
                          Adj_R_sqrd = round(summary(lmod)$adj.r.squared, 4),
                          AIC = round(AIC(lmod), 4))
    return(results)
  })
  fwd_fs <- do.call("rbind", fwd_fs) #viele dataframes -> ein dataframe
  
  if(!is.null(selected_vars)){
    formula <- paste(dep, " ~ ", paste(selected_vars, collapse=" + "))
    lmod <- lm(formula, data = data)
    results_selected <- data.frame(Variable = paste0("all: ", paste(selected_vars, collapse=", ")),#nur zur Info
                                   Adj_R_sqrd = round(summary(lmod)$adj.r.squared, 4),
                                   AIC = round(AIC(lmod), 4))
  } else {
    results_selected <- data.frame(Variable = paste0("all: ", paste(selected_vars, collapse=", ")),
                                   Adj_R_sqrd = 0, #initialisierung für da, wo es noch keinen Vergleichswert gibt
                                   AIC = 1E10)
  }
  fwd_fs <- rbind(results_selected, fwd_fs)
  
  # best_var <- as.character(fwd_fs$Variable[which(fwd_fs$AIC == min(fwd_fs$AIC))])
  # return(list(best_var, min(fwd_fs$AIC), fwd_fs))
  best_var <- as.character(fwd_fs$Variable[which(fwd_fs$Adj_R_sqrd == max(fwd_fs$Adj_R_sqrd))])
  return(list(best_var, max(fwd_fs$Adj_R_sqrd), fwd_fs))
}

#multiple model

dep <- "Winter_wheat"
next_vars <- names(cp)[-c(1:5, which(names(cp)==dep))]
act_run <- forward_feature_selection(data=cp, dep=dep, vars=next_vars)
forward_feature_selection(data=cp, dep=dep, vars=next_vars[-2], selected_vars="Winter_barley")#u.U. hinten mit combine mehrere
forward_feature_selection(data=cp, dep=dep, vars=next_vars[-2][-5], selected_vars="Winter_barley",)#u.U. hinten mit combine mehrere

#while ad_r-sq größer gleich zeile 1 weiter, sonst stop
dep <- "Winter_wheat"
next_vars <- names(cp)[-c(1:5, which(names(cp)==dep))]
act_run <- forward_feature_selection(data=cp, dep=dep, vars=next_vars)
forward_feature_selection(data=cp, dep=dep, vars=next_vars[-2], selected_vars="Winter_barley")#u.U. hinten mit combine mehrere
forward_feature_selection(data=cp, dep=dep, vars=next_vars[-2][-5], selected_vars="Winter_barley",)#u.U. hinten mit combine mehrere


##eigenes Ding

forward_feature_selection 
function(data, dep, vars, selected_vars = NULL)
  
while (results[1,2]>= 1)
{
  forward_feature_selection(cp,dep="Winter_wheat",vars=names(cp[8:16]))
}