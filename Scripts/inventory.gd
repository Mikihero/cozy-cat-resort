extends Control

var _rewarded_ad : RewardedAd
var _full_screen_content_callback := FullScreenContentCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func _ready() -> void:
	MobileAds.initialize()
	_full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		_enable()
	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	_full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
		
	#_on_load_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _disable():
	process_mode = Node.PROCESS_MODE_DISABLED
	$Overlay.show()

func _enable():
	process_mode = Node.PROCESS_MODE_INHERIT
	$Overlay.hide()

func load_ad():
	_disable()
	#free memory
	if _rewarded_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_rewarded_ad.destroy()
		_rewarded_ad = null

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5224354917"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/1712485313"
	
	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
		_enable()

	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad
		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback
		_on_show_pressed()
		
	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
	


func pay_to_watch():
	load_ad()
	Globals.GoldCatCoins -= 8
	on_user_earned_reward_listener.on_user_earned_reward = func(reward: RewardedItem):
		pass

func watch_for_coins():
	load_ad()
	on_user_earned_reward_listener.on_user_earned_reward = func(reward: RewardedItem):
		Globals.GoldCatCoins += 8

func _on_show_pressed():
	if _rewarded_ad:
		_rewarded_ad.show(on_user_earned_reward_listener)

func _on_close_pressed():
	queue_free()
