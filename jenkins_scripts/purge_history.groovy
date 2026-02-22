// change this variable to match the name of the job whose builds you want to delete
def jobName = "Wobbles_hazards/Build"
def job = Jenkins.instance.getItemByFullName(jobName)

job.getBuilds().each { it.delete() }
// uncomment these lines to reset the build number to 1:
job.nextBuildNumber = 1
job.save()
