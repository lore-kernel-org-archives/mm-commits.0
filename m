From: akpm@linux-foundation.org
Subject: [folded] crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:28:39 -0700
Message-ID: <20120323212839.D1D1DA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44452 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2CWV2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:28:40 -0400
Received: by yhgm50 with SMTP id m50so567497yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:28:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, djwong@us.ibm.com, linux@horizon.com, rpearson@systemfabricworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix
has been removed from the -mm tree.  Its filename was
     crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch

This patch was dropped because it was folded into crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix

fix typo, per George

Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: George Spelvin <linux@horizon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/crc32.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/crc32.txt~crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix Documentation/crc32.txt
--- a/Documentation/crc32.txt~crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix
+++ a/Documentation/crc32.txt
@@ -29,8 +29,8 @@ is sent last.  And when appending a CRC 
 do it in the right order, matching the endianness.
 
 Just like with ordinary division, you proceed one digit (bit) at a time.
-Each step of the division, division, you take one more digit (bit) of the
-dividend and append it to the current remainder.  Then you figure out the
+Each step of the division you take one more digit (bit) of the dividend
+and append it to the current remainder.  Then you figure out the
 appropriate multiple of the divisor to subtract to being the remainder
 back into range.  In binary, this is easy - it has to be either 0 or 1,
 and to make the XOR cancel, it's just a copy of bit 32 of the remainder.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

