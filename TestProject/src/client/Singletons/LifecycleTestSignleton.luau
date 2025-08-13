local singleton = {
	Implements = { "TEST_LIFECYCLE" },
}

function singleton:TEST_LIFECYCLE(sig, val)
	sig:Fire(val)
end

return singleton
