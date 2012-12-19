From: akpm@linux-foundation.org
Subject: + backlight-add-lms501kf03-lcd-driver-fix.patch added to -mm tree
Date: Wed, 19 Dec 2012 15:07:31 -0800
Message-ID: <20121219230732.9501920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:50722 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2LSXHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 18:07:35 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so138681eek.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 15:07:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Ilho215.lee@samsung.com, devendra.aaru@gmail.com, jg1.han@samsung.com


The patch titled
     Subject: backlight-add-lms501kf03-lcd-driver-fix
has been added to the -mm tree.  Its filename is
     backlight-add-lms501kf03-lcd-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-lms501kf03-lcd-driver-fix

remove unused variable `before_power'

Cc: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Ilho Lee <Ilho215.lee@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms501kf03.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix
+++ a/drivers/video/backlight/lms501kf03.c
@@ -388,7 +388,6 @@ static int lms501kf03_remove(struct spi_
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
 
 static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 {
@@ -396,8 +395,6 @@ static int lms501kf03_suspend(struct spi
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

