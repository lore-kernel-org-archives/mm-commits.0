From: akpm@linux-foundation.org
Subject: + fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch added to -mm tree
Date: Thu, 02 Oct 2008 23:52:24 -0700
Message-ID: <200810030652.m936qO8b015281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYJCGw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 02:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, varenet@parisc-linux.org


The patch titled
     fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanu=
ps
has been added to the -mm tree.  Its filename is
     fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanu=
ps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cl=
eanups
=46rom: Andrew Morton <akpm@linux-foundation.org>

- add trailing comma in table (so later alteratoins are cleaner)

- remove unneeded parentheses

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thibaut Var=E8ne <varenet@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in=
-epson-s1d13-video-driver-cleanups drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in-eps=
on-s1d13-video-driver-cleanups
+++ a/drivers/video/s1d13xxxfb.c
@@ -51,8 +51,8 @@
 #endif
=20
 static const int __devinitconst s1d13xxxfb_revisions[] =3D {
-	S1D13506_CHIP_REV,/* Rev.4 on HP Jornada 7xx S1D13506 */
-	S1D13806_CHIP_REV /* Rev.7 on .. */
+	S1D13506_CHIP_REV,	/* Rev.4 on HP Jornada 7xx S1D13506 */
+	S1D13806_CHIP_REV,	/* Rev.7 on .. */
 };
=20
 /*
@@ -623,9 +623,9 @@ s1d13xxxfb_probe(struct platform_device=20
 	}
=20
 	if (!ret)
-		printk(KERN_INFO PFX "chip revision %i\n", (revision));
+		printk(KERN_INFO PFX "chip revision %i\n", revision);
 	else {
-		printk(KERN_INFO PFX "unknown chip revision %i\n", (revision));
+		printk(KERN_INFO PFX "unknown chip revision %i\n", revision);
 		goto bail;
 	}
=20
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

include-linux-stacktraceh-declare-struct-task_struct.patch
git-powerpc.patch
git-sparc.patch
git-x86.patch
git-x86-git-rejects.patch
git-xtensa.patch
git-ftrace.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-acpi-git-rejects.patch
git-nfsd.patch
git-dlm.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-sound-rejects.patch
git-input.patch
git-block.patch
git-pcmcia-git-rejects.patch
git-battery.patch
git-mfd.patch
git-drm.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
drivers-media-video-tda9840c-unbreak.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.p=
atch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-t=
he-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_=
vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cle=
anup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.p=
atch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_proc=
ess-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix=
=2Epatch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix=
-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-c=
leanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanu=
p.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.pa=
tch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch=
-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-=
checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
