From: akpm@linux-foundation.org
Subject: [folded-merged] dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch removed from -mm tree
Date: Fri, 08 Mar 2013 12:18:46 -0800
Message-ID: <20130308201847.1AB7631C1CE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:44019 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3CHUSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 15:18:48 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so144183vbb.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 12:18:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben@decadent.org.uk, stable@vger.kernel.org, tmhikaru@gmail.com, zhenzhong.duan@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix
has been removed from the -mm tree.  Its filename was
     dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch

This patch was dropped because it was folded into dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix

Cc: <stable@vger.kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Tim McGrath <tmhikaru@gmail.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -460,7 +460,7 @@ static int __init smbios_present(const c
 			dmi_ver = 0x0206;
 			break;
 		}
-		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
+		return memcmp(p + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present.patch
include-linux-res_counterh-needs-errnoh.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
drivers-usb-dwc3-ep0c-fix-sparc64-build.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

