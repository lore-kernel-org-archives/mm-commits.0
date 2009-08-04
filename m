From: akpm@linux-foundation.org
Subject: + ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch added to -mm tree
Date: Tue, 04 Aug 2009 13:27:08 -0700
Message-ID: <200908042027.n74KR8dx018235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932387AbZHDU1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 16:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jgunthorpe@obsidianresearch.com, jsquyres@cisco.com, rolandd@cisco.com, rostedt@goodmis.org, sam@ravnborg.org


The patch titled
     ummunotify-userspace-support-for-mmu-notifications-v3 fix
has been added to the -mm tree.  Its filename is
     ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch

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
Subject: ummunotify-userspace-support-for-mmu-notifications-v3 fix
From: Andrew Morton <akpm@linux-foundation.org>

Documentation/ummunotify/umn-test.c:23:30: error: linux/ummunotify.h: No such file or directory
Documentation/ummunotify/umn-test.c:33: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
...

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jeff Squyres <jsquyres@cisco.com> 
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ummunotify/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/ummunotify/Makefile~ummunotify-userspace-support-for-mmu-notifications-v3-fix Documentation/ummunotify/Makefile
--- a/Documentation/ummunotify/Makefile~ummunotify-userspace-support-for-mmu-notifications-v3-fix
+++ a/Documentation/ummunotify/Makefile
@@ -4,4 +4,4 @@ hostprogs-y := umn-test
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_umn-test.o += -I$(objtree)/usr/include
+HOSTCFLAGS_umn-test.o += -I$(objtree)/include
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-amdc-fix-x86_64-allnoconfig-build.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
platform_device_add_data-use-kmemdup.patch
drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
slram-read-buffer-overflow-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
watchdog-add-sbc-fitpc2-watchdog-driver-fix.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

