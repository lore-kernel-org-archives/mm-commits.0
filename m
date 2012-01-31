From: akpm@linux-foundation.org
Subject: + net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch added to -mm tree
Date: Tue, 31 Jan 2012 13:33:43 -0800
Message-ID: <20120131221627.36348100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45493 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2AaWQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 17:16:29 -0500
Received: by yenl2 with SMTP id l2so73866yen.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 14:16:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, philipp@redfish-solutions.com, rpurdie@rpsys.net, tglx@linutronix.de


The patch titled
     Subject: net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
has been added to the -mm tree.  Its filename is
     net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch

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
Subject: net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix

remove Kconfig and Makefile detritus from drivers/leds/

make[2]: *** No rule to make target `drivers/leds/leds-net5501.c', needed by `drivers/leds/leds-net5501.o'.  Stop.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Philip Prindeville <philipp@redfish-solutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig  |   10 ----------
 drivers/leds/Makefile |    1 -
 2 files changed, 11 deletions(-)

diff -puN drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
+++ a/drivers/leds/Kconfig
@@ -89,16 +89,6 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
-config LEDS_NET5501
-	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_TRIGGERS
-	depends on X86 && GPIO_CS5535
-	select LEDS_TRIGGER_DEFAULT_ON
-	default n
-	help
-	  Add support for the Soekris net5501 board (detection, error led
-	  and GPIO).
-
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix drivers/leds/Makefile
--- a/drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
+++ a/drivers/leds/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= led
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
-obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
_
Subject: Subject: net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

