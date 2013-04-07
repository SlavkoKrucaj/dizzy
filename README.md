#Dizzy

##About

Dizzy is gem which allows you to create CocoaPod for your resources. Dizzy also creates `Resources` class of static methods to get your resources. For instance if you have resources like this

```
| resources
| |-back_button.png
| |-back_button@2x.png
| |-next.png
| |-next@2x.png
```

you would be able to access this resources like `[Resources resBackButton]` which returns `UIImage` for `back_button`. This way if someone **deletes resource** in a new version of a pod, you will get **compiler error** that the resource is missing and you will have 'autocompletion' for resource names.

Since **Dizzy** creates a pod, you can use your resources just as any other pod. You just have to specify it in your `Podfile` like `pod '[NAME_OF_YOUR_POD]'`

##Installation and usage

To install dizzy, you should run the following

```
	$ gem install dizzy
```

###Dizzy your folder

```
	$ cd path/to/folder
	$ dizzy start --repo=[REPO] --spec=[SPEC] --name=[NAME_OF_YOUR_POD]
```
where `[REPO]` is link to github repo where you will store the resources for pod to install i.e. `git@github.com:SlavkoKrucaj/RandomResourceProject`. `[SPEC]` is link to CocoaPods specs repository where `.podspec` will be install.

###Pushing dizzy

After you have some resources in your folder and want to push them as a pod you have do the following

```
	$ cd path/to/folder
	$ dizzy push --message="Custom message" --tag-0.0.3
```
	
This will push changes to your github repo and create and push pod to specified spec repo.

###Getting the latest tag version

```
	$ cd path/to/folder
	$ dizzy version
	0.0.3
```
###Undizzy your folder

```
	$ cd path/to/folder
	$ dizzy clean
```