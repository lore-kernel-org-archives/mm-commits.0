From: akpm@linux-foundation.org
Subject: [folded] lis3-update-documentation-to-match-latest-changes-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:12:55 -0800
Message-ID: <200912150112.nBF1Ctbv026483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbZLOBVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Eric.Piel@tremplin-utc.net, pavel@ucw.cz, randy.dunlap@oracle.com, samu.p.onkalo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     lis3-update-documentation-to-match-latest-changes-fix
has been removed from the -mm tree.  Its filename was
     lis3-update-documentation-to-match-latest-changes-fix.patch

This patch was dropped because it was folded into lis3-update-documenta=
tion-to-match-latest-changes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3-update-documentation-to-match-latest-changes-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

Cc: Pavel Machek <pavel@ucw.cz>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/lis3lv02d |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/hwmon/lis3lv02d~lis3-update-documentation-to-ma=
tch-latest-changes-fix Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~lis3-update-documentation-to-match-=
latest-changes-fix
+++ a/Documentation/hwmon/lis3lv02d
@@ -40,7 +40,7 @@ Events are also available as input event
=20
 Selftest is meant only for hardware diagnostic purposes. It is not mea=
nt to be
 used during normal operations. Position data is not corrupted during s=
elftest
-but interrupt behaviour is not quaranteed to work reliably. In test mo=
de, the
+but interrupt behaviour is not guaranteed to work reliably. In test mo=
de, the
 sensing element is internally moved little bit. Selftest measures diff=
erence
 between normal mode and test mode. Chip specifications tell the accept=
ance
 limit for each type of the chip. Limits are provided via platform data
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap=
=2Epatch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.pat=
ch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_space=
s.patch
lib-introduce-strim.patch
blackfin-sd-host-controller-driver.patch
crc32-minor-optimizations-and-cleanup.patch
hwmon-w83627ehf-updates.patch
lis3-update-documentation-to-match-latest-changes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
