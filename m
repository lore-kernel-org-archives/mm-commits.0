From: akpm@linux-foundation.org
Subject: + thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch added to -mm tree
Date: Mon, 12 Jan 2009 22:52:03 -0800
Message-ID: <200901130652.n0D6q3cP006095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757613AbZAMGwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 01:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hmh@hmh.eng.br, hpa@zytor.com, mingo@elte.hu, pavel@suse.cz, rpurdie@rpsys.net, tglx@linutronix.de


The patch titled
     thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#218: FILE: drivers/platform/x86/thinkpad_acpi.c:4092:
+                       TPACPI_LED_OFF :$

ERROR: code indent should use tabs where possible
#219: FILE: drivers/platform/x86/thinkpad_acpi.c:4093:
+                       (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?$

ERROR: code indent should use tabs where possible
#220: FILE: drivers/platform/x86/thinkpad_acpi.c:4094:
+                              TPACPI_LED_BLINK : TPACPI_LED_ON);$

total: 3 errors, 0 warnings, 225 lines checked

./patches/thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -4089,9 +4089,9 @@ static int led_set_class_status(struct d
 	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
 		return -EINVAL;
 	return led_set_status(data->led, (data->new_brightness == LED_OFF) ?
-                       TPACPI_LED_OFF :
-                       (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?
-                              TPACPI_LED_BLINK : TPACPI_LED_ON);
+		    TPACPI_LED_OFF :
+		    (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?
+			TPACPI_LED_BLINK : TPACPI_LED_ON);
 }
 
 static int led_sysfs_blink_set(struct led_classdev *led_cdev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
alpha-fix-vmalloc-breakage-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

