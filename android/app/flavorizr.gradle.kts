import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("local") {
            dimension = "flavor-type"
            applicationId = "com.neythuaung.attendly.local"
            resValue(type = "string", name = "app_name", value = "Attendly Local")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.neythuaung.attendly.staging"
            resValue(type = "string", name = "app_name", value = "Attendly Staging")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.neythuaung.attendly"
            resValue(type = "string", name = "app_name", value = "Attendly")
        }
    }

    buildFeatures.resValues = true
}
