From: akpm@linux-foundation.org
Subject: [folded] video-initial-support-for-adv7180-update-fix.patch removed from -mm tree
Date: Fri, 18 Sep 2009 12:46:45 -0700
Message-ID: <200909181946.n8IJkj4V013695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbZIRTrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 15:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hverkuil@xs4all.nl, mchehab@infradead.org, richard.rojfors.ext@mocean-labs.com, mm-commits@vger.kernel.org


The patch titled
     video-initial-support-for-adv7180-update-fix
has been removed from the -mm tree.  Its filename was
     video-initial-support-for-adv7180-update-fix.patch

This patch was dropped because it was folded into video-initial-support=
-for-adv7180.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: video-initial-support-for-adv7180-update-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

remove unneeded cast.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/adv7180.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/adv7180.c~video-initial-support-for-adv71=
80-update-fix drivers/media/video/adv7180.c
--- a/drivers/media/video/adv7180.c~video-initial-support-for-adv7180-u=
pdate-fix
+++ a/drivers/media/video/adv7180.c
@@ -90,7 +90,7 @@ static int adv7180_querystd(struct v4l2_
 {
 	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
=20
-	*(v4l2_std_id *)std =3D determine_norm(client);
+	*std =3D determine_norm(client);
 	return 0;
 }
=20
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-n=
ew-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by=
-using-smp_call_function_any.patch
hwmon-driver-for-acpi-40-power-meters.patch
drivers-md-dm-log-userspace-basec-fix-warning.patch
video-initial-support-for-adv7180.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sys=
fs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.p=
atch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
net-fix-config_net=3Dn-build-on-sparc64.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fix=
es.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatc=
h-fixes.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
drivers-usb-serial-sierrac-fix-config_pm=3Dn-build.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-=
space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes=
=2Epatch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-=
buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-che=
ckpatch-fixes.patch
mm-zero_page-without-pte_special-mips-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
include-linux-credh-fix-build.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-to-use-arch_gettimeoffset-fix.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fi=
x.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cl=
eanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-check=
patch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fix=
es.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch=
-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-c=
heckpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
