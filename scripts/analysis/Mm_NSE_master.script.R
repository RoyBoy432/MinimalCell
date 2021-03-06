rm(list = ls())
package.list <- c('ggplot2','tidyverse','dplyr','ggpubr','Hmisc', 'psych', 'ggrepel', 'lme4', 'plm','car','gplots','tseries','lmtest')
for (package in package.list) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}
theme_set(
  theme_bw()
)

setwd("~\\..\\GitHub\\MinimalCell")

mydf<-read_csv("data\\cases_Mm.300.csv")
#mydf<-read_csv("C:\\Users\\rmoge\\Box Sync\\Mycoplasma\\Experiments\\data\\cases_Mm.300_1.2.csv")
mydf$Strain <- factor(mydf$Strain, levels=c("Wildtype","Minimal"))
mycols<-c("black","black")
#levels(NSEOD$Strain)[levels(NSEOD$Strain)=="3b"] <- "JCVI-syn3B"
#levels(NSEOD$Strain)[levels(NSEOD$Strain)=="s1"] <- "JCVI-syn1.0"
#levels(NSEOD$Time)[levels(NSEOD$Time)=="anc"] <- "Ancestor"
#levels(NSEOD$Time)[levels(NSEOD$Time)=="evolved"] <- "Evolved"
#mydf$Strain<-factor(mydf$Strain, levels=c("JCVI-syn1.0","JCVI-syn3B"))


#Here is a quick plot of the dNdS values for both strains.

dnds <- ggplot(mydf, aes(x=Strain, y=dNdS_gdtools))
dnds + geom_jitter(
  aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
  position = position_jitterdodge(jitter.width = .9, dodge.width = .2),
  size = 8, stroke = 2.3) +
  scale_shape_manual(values = c(15,0)) +#12 is a square with a vertical cross inside it
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (2)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2),
    show.legend = FALSE
  ) +
  scale_color_manual(values = mycols) +
  labs(x="\nStrain",y="dN/dS\n") +
  geom_hline(yintercept = 1, linetype=117, size = 1.25) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.position = "none",legend.key=element_blank(),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line = element_line(colour = "black"), axis.line.x = element_blank(), axis.line.y = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())

#Now same plot with theme colors
brcols<-c("blue","red")
dnds <- ggplot(mydf, aes(x=Strain, y=dNdS_gdtools))
dnds +  #geom_errorbar(aes(ymax=c(1,1,1,1,0.479184263,0.479184263,0.479184263,0.479184263),ymin=c(1,1,1,1,0.479184263,0.479184263,0.479184263,0.479184263)), color=c("blue","blue","blue","blue","red","red","red","red"),lwd = 2.2,linetype=117) +
  geom_hline(yintercept = 1, linetype=117, size = 1.25, color = "darkgrey") +
  geom_jitter(
    aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
    position = position_jitterdodge(jitter.width = 0.575, dodge.width = 0.2),
    size = 8, stroke=2.3) +
  scale_shape_manual(values = c(0,0)) +
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (1)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2),
    show.legend=FALSE
  ) +
  ylim(0,3.5)+
  scale_color_manual(values = brcols) +
  labs(x="\n",y= ~ atop(paste("",italic("dN/dS"),""),###this adds the text that I want
                        paste(scriptstyle(" ")))) +                           ###however, trying to paste \n messes everything up. Therefore, to gain space between the title and th axis line, I pasted another argument---this starts pn a new line, and, since it was blank, it just functions like \n in this case
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())#+
#theme(legend.position="none")

#Now quick statistical tests on the dnds values
mydnds<- read.csv("data\\case.Mm.dNdS_gdtools.csv",header=T)
shapiro.test(mydnds$Wildtype)
shapiro.test(mydnds$Minimal)

dnds.f<-var.test(mydnds$Wildtype,mydnds$Minimal,ratio=1,alternative = 'two.sided')
print(dnds.f)

dnds.t<-t.test(mydnds$Wildtype,mydnds$Minimal,var.equal=TRUE,alternative = 'g')
print(dnds.t)

wt1<-t.test(mydnds$Wildtype,mu=1,alternative = 'g')
print(wt1)
min1<-t.test(mydnds$Minimal,mu=1,alternative = 'g')
print(min1)

wtx<-wilcox.test(mydnds$Wildtype,mu=1,alternative = 'g')
print(wtx)
minx<-wilcox.test(mydnds$Minimal,mu=1,alternative = 'g')
print(minx)

#################################################################
#Compare proportions of significant genes of different categories in NSE
x1s1<-4;x13b<-1;ns1<-16;n3b<-14
membrane.transport<-prop.test(x=c(x1s1,x13b),n=c(ns1,n3b),alternative = 't');membrane.transport
#membrane.transport<-binom.test(x=c(x1s1,ns1-x1s1),p=2/4,alternative = 't');membrane.transport
membrane.transport<-fisher.test(x=matrix(c(x1s1,ns1-x1s1,x13b,n3b-x13b),ncol=2));membrane.transport

x2s1<-2;x23b<-2;ns1<-16;n3b<-14
glucose.metabolism<-prop.test(x=c(x2s1,x23b),n=c(ns1,n3b),alternative = 't');glucose.metabolism
#glucose.metabolism<-binom.test(x=c(x2s1,x23b),n=c(ns1,n3b),alternative = 't');glucose.metabolism
glucose.metabolism<-fisher.test(x=matrix(c(x2s1,ns1-x2s1,x23b,n3b-x23b),ncol=2));glucose.metabolism


##################################################################
#Make figures that Will wanted for his presentation at Cocoa Beach
brcols<-c("blue","red")
W_per_gen <- ggplot(mydf, aes(x=Strain, y=abs_W_per_gen))
W_per_gen + geom_jitter(
  aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
  position = position_jitterdodge(jitter.width = 0.475, dodge.width = 0.2),
  size = 5.5) +
  scale_shape_manual(values = c(0,0)) +#12 is a square with a vertical cross inside it
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (1)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2)
  ) +
  scale_color_manual(values = brcols) +
  labs(x="\nStrain",y="Fitness gain per generation\n") +
  geom_hline(yintercept = 0, linetype=117, size = 1.25) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x = element_line(color="black", size = 1.5), axis.line.y = element_line(color="black", size = 1.5), axis.ticks.y = element_line(color = "black", size = 1.5), axis.ticks.x = element_blank())

brcols<-c("blue","red")
W_per_gen <- ggplot(mydf, aes(x=Strain, y=abs_W_per_day))
W_per_gen + geom_jitter(
  aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
  position = position_jitterdodge(jitter.width = 0.475, dodge.width = 0.2),
  size = 5.5) +
  scale_shape_manual(values = c(0,0)) +#12 is a square with a vertical cross inside it
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (1)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2)
  ) +
  scale_color_manual(values = brcols) +
  labs(x="\nStrain",y="Fitness gain per day\n") +
  geom_hline(yintercept = 0, linetype=117, size = 1.25) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x = element_line(color="black", size = 1.5), axis.line.y = element_line(color="black", size = 1.5), axis.ticks.y = element_line(color = "black", size = 1.5), axis.ticks.x = element_blank())










############
#Analyze changes in fitness during NSE

idff<-read_csv("data\\mean.SE_Mm.300.csv")
BANC<-idff$W_anc1.0[2] / idff$W_anc.own[2]


myt <- read.csv("data\\cases_Mm.300.csv",header=T)
#myt <- read.csv("C:\\Users\\rmoge\\Box Sync\\Mycoplasma\\Experiments\\data\\cases_Mm.300_1.2.csv",header=T)

#
myd<-as_tibble(mydf)
my1<-filter(myd,Strain_technical=='syn1.0')
myB<-filter(myd,Strain_technical=='syn3B')
#myd<-add_column(myd, mu=(1/e0))

V<-var.test(my1$W_anc1.0,myB$W_anc1.0)
V

absoluteW<-t.test(my1$W_anc1.0,myB$W_anc1.0,alternative='two.sided',paired=F,var.equal=T,mu=0)
absoluteW

vi<-var.test(my1$W_anc.own,myB$W_anc.own)
vi

increaseWvsown<-t.test(my1$W_anc.own,myB$W_anc.own,alternative='two.sided',paired=F,var.equal=T,mu=(0))
print(increaseWvsown)

vabsincrease<-var.test(my1$W_anc1.0,myB$W_anc1.0)
vabsincrease


Wabsincrease<-t.test(my1$W_anc1.0,myB$W_anc1.0,alternative="t",paired=F,var.equal=T,mu=(1-BANC))
Wabsincrease
Wabsincrease<-t.test(my1$W_anc1.0,myB$W_anc1.0,alternative="g",paired=F,var.equal=T,mu=(1-BANC))
Wabsincrease
1.3235616-0.8428967

#############
#OLD bar chart comparing fitness gains 
mygg<-ggplot(idff, aes(x=Strain,y=W_anc1.0,fill=Strain)) +
  geom_bar(aes(x=Strain, y=W_anc1.0),position=position_dodge(.1), inherit.aes = TRUE, stat= "identity", colour="black", width = .5) +
  geom_errorbar(aes(Strain, ymin = (W_anc1.0 - 1*W_anc1.0_SE), ymax = (W_anc1.0 + 1*W_anc1.0_SE)),position = position_dodge(1), width = .15, size = 1.5) +
  labs(x="Strain", y="Relative fitness (W)") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"), axis.text=element_text(size=22),axis.title=element_text(size=34), axis.line.x = element_line(color="black", size = 1.5), axis.line.y = element_line(color="black", size = 1.5), axis.ticks.y = element_line(color = "black", size = 1.5), axis.ticks.x = element_blank(), axis.ticks.length = unit(0.2, "cm"), aspect.ratio = 2/1) +
  scale_y_continuous(limits = c(0,1.506), expand = c(0,0)) +
  geom_hline(yintercept = 1, linetype=117, size = 1.25) + 
  geom_hline(yintercept = (BANC), linetype=117,col='red', size = 1.25) +
  scale_fill_manual("",values = c("syn1.0"=" dark grey","syn3B"="salmon"))
plot(mygg)

############
#OLD strip chart comparing gitness gains
myd
levels(myd$Strain_technical)[levels(myd$Strain_technical)=="syn3B"] <- "JCVI-syn3B"
levels(myd$Strain_technical)[levels(myd$Strain_technical)=="syn1.0"] <- "JCVI-syn1.0"
#levels(myt$Time)[levels(myt$Time)=="anc"] <- "Ancestor"
#levels(myt$Time)[levels(myt$Time)=="evolved"] <- "Evolved"
myd$Strain_technical<-factor(myd$Strain_technical, levels=c("JCVI-syn1.0","JCVI-syn3B"))

brcols<-c("blue","red")
Wfig <- ggplot(myd, aes(x=Strain, y=W_anc1.0))
Wfig +  geom_errorbar(aes(ymax=c(1,1,1,1,0.479184263,0.479184263,0.479184263,0.479184263),ymin=c(1,1,1,1,0.479184263,0.479184263,0.479184263,0.479184263)), color=c("blue","blue","blue","blue","red","red","red","red"),lwd = 2.2,linetype=117) +
  geom_jitter(
    aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
    position = position_jitterdodge(jitter.width = 0.575, dodge.width = 0.2),
    size = 8, stroke=2.3) +
  scale_shape_manual(values = c(0,0)) +
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (1)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2),
    show.legend=FALSE
  ) +
  scale_color_manual(values = brcols) +
  labs(x="\n",y= ~ atop(paste("Relative fitness (",italic("W'"),")"),###this adds the text that I want
                        paste(scriptstyle(" ")))) +                           ###however, trying to paste \n messes everything up. Therefore, to gain space between the title and th axis line, I pasted another argument---this starts pn a new line, and, since it was blank, it just functions like \n in this case
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())#+
#theme(legend.position="none")

interaction_data<-read_csv("data\\Interaction_data.csv")
idata=as_tibble(interaction_data)

idata2<-idata %>% group_by(timepoint, strain) %>% summarise(y_mean = mean(W_1.0), y_se = psych::describe(W_1.0)$se)

# Creating the plot
idata2 %>% 
  ggplot(aes(x = timepoint, 
             y = y_mean, 
             color = strain)) +
  geom_line(aes(group = strain),cex=2.5) +
  geom_point(cex = 7.5) +
  geom_errorbar(aes(ymin = y_mean-2*y_se,ymax = y_mean+2*y_se),width = .1,size=2.5) +
  ylim(0, 2) +
  labs(x = "\nTimepoint",
       color  = "Strain",
       y = ~ atop(paste("Relative fitness (",italic("W"),")"),###this adds the text that I want
                  paste(scriptstyle(" ")))) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank()) +
  scale_color_manual(values = brcols)

# create the plot with alternate legend
idata2 %>% 
  ggplot(aes(x = c(1,1,1.5,1.5),
             y = y_mean, 
             color = strain)) +
  geom_line(aes(group = strain),cex=2.5) +
  geom_point(cex = 7.5) +
  geom_errorbar(aes(ymin = y_mean-2*y_se,ymax = y_mean+2*y_se),width = .1,size=2.5) +
  ylim(0, 2) +
  xlim(0.9,1.75) +
  coord_fixed(ratio=0.35,clip="off")+
  annotate(geom="text",x=1.66,y=0.842896745,label='Minimal', color = "black",size=13)+
  annotate(geom="text",x=1.66,y=1.323561568,label='Wildtype', color = "black",size=13)+
  geom_text(x=1,y=-0.22,label="Ancestor",size=12,color="dark grey")+
  geom_text(x=1.5,y=-0.22,label="Evolved",size=12,color="dark grey")+
  labs(x = "\nTimepoint",
       color  = "Strain",
       y = ~ atop(paste("Relative fitness (",italic("W"),")"),###this adds the text that I want
                  paste(scriptstyle(" ")))) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  #scale_x_discrete(expand = c(0.1,0.1)) +
  theme(legend.position='none',legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank(),  axis.text.x=element_blank()) +
  scale_color_manual(values = brcols)

###########
#Analyze changes in OD during the NSE
myOD<-read_csv("data\\OD_600\\20200327_OD.600_summ2way.csv")
NSEOD<-as_tibble(myOD)
NSEOD$Strain <- as.factor(NSEOD$Strain);NSEOD$Time <- as.factor(NSEOD$Time)
levels(NSEOD$Strain)[levels(NSEOD$Strain)=="3b"] <- "JCVI-syn3B"
levels(NSEOD$Strain)[levels(NSEOD$Strain)=="s1"] <- "JCVI-syn1.0"
levels(NSEOD$Time)[levels(NSEOD$Time)=="anc"] <- "Ancestor"
levels(NSEOD$Time)[levels(NSEOD$Time)=="evolved"] <- "Evolved"
NSEOD$Strain<-factor(NSEOD$Strain, levels=c("JCVI-syn1.0","JCVI-syn3B"))

###############
#t-test: Mean of evolved OD versus fixed ancestor value, for syn3B
bNSE<- NSEOD %>% filter(Time=="Evolved") %>% filter(Strain=="JCVI-syn3B")
t.test(x=bNSE$OD,mu=0.079333333,alternative = "g")
#0.001131
#t-test: Mean of evolved OD versus fixed ancestor value, for syn1.0
s1NSE <- NSEOD %>% filter(Time=="Evolved") %>% filter(Strain=="JCVI-syn1.0")
t.test(x=s1NSE$OD,mu=0.876333333,alternative = "g")
#P = 0.0007063

NSEevo<- NSEOD %>% filter(Time=="Evolved")

#####################
#quick strip chart comparing ODs
brcols<-c("blue","red")
ODfig <- ggplot(NSEevo, aes(x=Strain, y=OD))
ODfig +   geom_errorbar(aes(ymax=c(0.079333333,0.079333333,0.079333333,0.079333333,0.876333333,0.876333333,0.876333333,0.876333333),ymin=c(0.079333333,0.079333333,0.079333333,0.079333333,0.876333333,0.876333333,0.876333333,0.876333333)), color=c("red","red","red","red","blue","blue","blue","blue"),lwd = 2.2,linetype=117) +
  geom_jitter(
    aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
    position = position_jitterdodge(jitter.width = 0.475, dodge.width = 0.2),
    size = 8, stroke=2.3) +
  scale_shape_manual(values = c(0,0)) +
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (1)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2),
    show.legend=FALSE
  ) +
  scale_color_manual(values = brcols) +
  labs(x="\n",y="OD 600 after 8 days\n") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())#+
#theme(legend.position="none")


####################################
#an interaction plot for gains in OD
interaction_data_OD<-read_csv("data\\Interaction_data_OD.csv")
idata_OD=as_tibble(interaction_data_OD)

idata2_OD<-idata_OD %>% group_by(timepoint, strain) %>% summarise(y_mean = mean(OD), y_se = psych::describe(OD)$se)

# Creating the plot
idata2_OD %>% 
  ggplot(aes(x = timepoint, 
             y = y_mean, 
             color = strain)) +
  geom_line(aes(group = strain),cex=2.5) +
  geom_point(cex = 7.5) +
  geom_errorbar(aes(ymin = y_mean-2*y_se,ymax = y_mean+2*y_se),width = .1,size=2.5) +
  ylim(0, 2) +
  labs(x = "\nTimepoint",
       color  = "Strain",
       y = "OD 600") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank()) +
  scale_color_manual(values = brcols)





mycols<-c("black","black")

#####################################
#Alternate strip chart for the OD data
pgcols<-c("blue","blue","red","red")
#("red","red","red","red","red","red","red","red","red","red","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue")
ODfig_allv <- ggplot(NSEOD, aes(x=Time, y=OD))
ODfig_allv +  geom_jitter(
  aes(shape = Time, color = Strain),
  position = position_jitterdodge(jitter.width = 0.5, dodge.width = 0.4),
  size = 8, stroke = 2.3, show.legend=FALSE
) +
  scale_shape_manual(values = c(0,15)) +
  stat_summary(
    aes(color = c("red","red","red","red","red","red","red","red","red","red","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue")),
    fun.data = "mean_se", fun.args = list(mult = (2)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.8, shape = 95,
    position = position_dodge(0.4),
    show.legend = FALSE) +
  scale_color_manual(values = pgcols) +
  labs(x="\nTime point",y="OD 600 after 8 days\n") +                           ###however, trying to paste \n messes everything up. Therefore, to gain space between the title and th axis line, I pasted another argument---this starts pn a new line, and, since it was blank, it just functions like \n in thise case
  scale_y_continuous(limits = c(-0.1,2.2), expand = c(0,0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())



##########################################################
###Analysis of the outputs from imageJ/ MicrobeJ

mjdf<-read_csv("data\\microscopy\\microbeJ_results\\cases_microbeJ.csv")
#mydf<-read_csv("C:\\Users\\rmoge\\Box Sync\\Mycoplasma\\Experiments\\data\\cases_Mm.300_1.2.csv")
#mydf$Strain <- factor(mydf$Strain, levels=c("Wildtype","Minimal"))
mjcols<-c("black","black","black","black","black","black","black","black","black","black")
#mycols<-c("white","white","white","white","white","white","white","white","white","white")

Area3B<-c(0.313133103,0.144968712,0.179881286,0.150747882)
Areas1<-c(1.054317474,          0.728156189,          0.62265075, 0.810654429)

V3B<-c(0.151059057,0.044795865,0.069656583,0.061471671)
Vs1<-c(0.864361014,0.489121054,0.387076679,0.558433799)

shapiro.test(Area3B)
shapiro.test(Areas1)
shapiro.test(sqrt(Area3B))
shapiro.test(sqrt(Areas1))


t.test(x=Area3B,mu=0.160169625,alternative = "two.sided")
t.test(x=Areas1,mu=0.278401246,alternative = "two.sided")

t.test(x=sqrt(Area3B),mu=sqrt(0.160169625),alternative = "two.sided")
t.test(x=sqrt(Areas1),mu=sqrt(0.392750088),alternative = "two.sided")

shapiro.test(V3B)
shapiro.test(Vs1)
t.test(x=V3B,mu=0.057819371,alternative = "two.sided")
t.test(x=Vs1,mu=0.122741212,alternative = "two.sided")



areaV<-aov(mjdf$Area ~ mjdf$Strain)
summary(areaV)
TukeyHSD(areaV)

diamV<-aov(mjdf$Diameter ~ mjdf$Strain)
summary(diamV)
TukeyHSD(diamV)

VV<-aov(mjdf$Volume ~ mjdf$Strain)
summary(VV)
TukeyHSD(VV)
#####Could do this as a GLM. Fixed effects: Timepoint (anc, or evolved) as fixed effect. Strain as a fixed effect. Replicate evolution as a random effect. ????
modelV <- lmer(mjdf$Volume ~ mjdf$Timepoint + mjdf$Genotype + (mjdf$Timepoint | mjdf$Strain))
summary(modelV)

######
#Look for statistical correlation between population fitness and population average cell size
Area3B_all<-c(0.313133103,0.144968712,0.179881286,0.150747882,0.160169625)
Areas1_all<-c(1.054317474,          0.728156189,          0.62265075, 0.810654429,0.392750088)
W3B_all<-c(0.971022482,0.806202409, 0.800146358,0.794215732,0.479184263)
Ws1_all<-c(1.097961341, 1.428011332,1.509297996,1.258975605,1)
Volume3B_all<-Area3B_all^1.5
Volumes1_all<-Areas1_all^1.5

cor(Area3B_all,W3B_all)
cor.test(Area3B_all,W3B_all,alternative = "two.sided", method = "pearson")#did the correlation on cell AREA because surface area is what scales with membrane transport, &c)
cor.test(Areas1_all,Ws1_all,alternative = "two.sided", method = "pearson")

cor(Volume3B_all,W3B_all)
cor.test(Volume3B_all,W3B_all,alternative = "two.sided", method = "pearson")#also test for correlation with cell volume?
cor(Volumes1_all,Ws1_all)
cor.test(Volumes1_all,Ws1_all,alternative = "two.sided", method = "pearson")

###############
##Wide/ANOVA style strip chart for all of the cell size values

mj <- ggplot(mjdf, aes(x=Strain, y=Area))
mj + geom_jitter(
  aes(shape = Strain, color = Strain), #I cut out the "shape = Evolution, " part of the aes so that all shapes would be the same shape
  position = position_jitterdodge(jitter.width = .1, dodge.width = .5),
  size = 1, stroke = 1.3) +
  scale_shape_manual(values = c(1,1,1,1,1,1,1,1,1,1)) +#12 is a square with a vertical cross inside it
  stat_summary(
    aes(color = Strain),
    fun.data = "mean_se", fun.args = list(mult = (2)), #mean_sdl add +/- standard deviation; mult=1 means that it is SD*1 that is drawn.  Mean_se draws the standard error of the mean
    geom = "pointrange", size = 1.5, shape=95,
    position = position_dodge(0.2),
    show.legend = FALSE
  ) +
  scale_color_manual(values = mjcols) +
  labs(x="\nStrain",y="Cell area (pixels)\n") +
  theme(axis.text.x = element_text(angle=45, vjust=0.5, size =26)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.position = "none",legend.key=element_blank(),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line = element_line(colour = "black"), axis.line.x = element_blank(), axis.line.y = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank())

###################################
#Interaction plot for the cell size data
interaction_data_ftsz<-read_csv("data\\Interaction_data_ftsz.csv")
idata_ftsz=as_tibble(interaction_data_ftsz)

idata_ftsz_area<-idata_ftsz %>% group_by(timepoint, strain) %>% summarise(y_mean = mean(Area), y_se = psych::describe(Area)$se)
line_area <- expression(atop(~"Area"  ~(�m^2 )))
idata_ftsz2<-idata_ftsz %>% group_by(timepoint, strain) %>% summarise(y_mean = mean(Volume), y_se = psych::describe(Volume)$se)

#line_1c <- expression("Various fonts:" ~ bolditalic("bolditalic") ~ bold("bold") ~ italic("italic"))
#line_2c <- expression("this" ~~ sqrt(x, y) ~~ "or this" ~~ sum(x[i], i==1, n) ~~ "math expression")

# the ~~ adds a bit more space than ~ between the expression's components

#p + coord_cartesian(clip = "off") +
#  annotation_custom(grid::textGrob(line_1c), xmin = 3.5, xmax = 3.5, ymin = 7.3, ymax = 7.3) +
#  annotation_custom(grid::textGrob(line_2c), xmin = 3.5, xmax = 3.5, ymin = 5.5, ymax = 5.5)

# Creating the plot
line3 <- expression(atop(~"Volume"  ~(�m^3 )))
idata_ftsz2 %>% 
  ggplot(aes(x = timepoint, 
             y = y_mean, 
             color = strain)) +
  geom_line(aes(group = strain),cex=2.5) +
  geom_point(cex = 7.5) +
  geom_errorbar(aes(ymin = y_mean-2*y_se,ymax = y_mean+2*y_se),width = .1,size=2.5) +
  ylim(0, 1) +
  labs(x = "\nTimepoint",color  = "Strain",y=line3) +
  
  #ylab(expression(atop(paste("Area (�m" ^2)))) +
  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  theme(legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank()) +
  scale_color_manual(values = brcols)

# create the plot with alternate legend
line3 <- expression(atop(~"Cell volume"  ~(�m^3 )))
idata_ftsz2 %>% 
  ggplot(aes(x = c(1,1,1.25,1.25),
             y = y_mean, 
             color = strain)) +
  geom_line(aes(group = strain),cex=2.5) +
  geom_point(cex = 7.5) +
  geom_errorbar(aes(ymin = y_mean-2*y_se,ymax = y_mean+2*y_se),width = .05,size=2.5) +
  ylim(0, 1) +
  xlim(0.9,1.5) +
  coord_fixed(ratio=0.35,clip="off")+
  annotate(geom="text",x=1.41,y=0.062,label='Minimal', color = "black",size=13)+
  annotate(geom="text",x=1.41,y=0.544,label='Wildtype', color = "black",size=13)+
  geom_text(x=1,y=-0.1,label="Ancestor",size=12,color="dark grey")+
  geom_text(x=1.25,y=-0.1,label="Evolved",size=12,color="dark grey")+
  labs(x = "\nTimepoint",
       color  = "Strain",
       y = line3) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), panel.border = element_rect(color = "black", fill = NA, size = 3.5), axis.line = element_line(colour = "black")) +
  #scale_x_discrete(expand = c(0.1,0.1)) +
  theme(legend.position='none',legend.key=element_blank(),legend.key.size = unit(2, "lines"),axis.text=element_text(size=34),axis.title=element_text(size=36),legend.text=element_text(size=22),legend.title = element_text(size=34), axis.line.x.bottom = element_blank(), axis.line.y.left = element_blank(), axis.ticks.y = element_line(color = "black", size = 3.5), axis.ticks.length = unit (.3, "cm"), axis.ticks.x = element_blank(),  axis.text.x=element_blank()) +
  scale_color_manual(values = brcols)
