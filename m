From: akpm@linux-foundation.org
Subject: + adt7473-minor-documentation-update.patch added to -mm tree
Date: Tue, 01 Apr 2008 11:18:21 -0700
Message-ID: <200804011818.m31IIL1L006730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616AbYDASS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 14:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     adt7473: minor documentation update
has been added to the -mm tree.  Its filename is
     adt7473-minor-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7473: minor documentation update
From: "Darrick J. Wong" <djwong@us.ibm.com>

Add a sentence about when fan speed increases to maximum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/adt7473 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/hwmon/adt7473~adt7473-minor-documentation-update Documentation/hwmon/adt7473
--- a/Documentation/hwmon/adt7473~adt7473-minor-documentation-update
+++ a/Documentation/hwmon/adt7473
@@ -69,7 +69,8 @@ point2: Set the pwm speed at a higher te
 
 The ADT7473 will scale the pwm between the lower and higher pwm speed when
 the temperature is between the two temperature boundaries.  PWM values range
-from 0 (off) to 255 (full speed).
+from 0 (off) to 255 (full speed).  Fan speed will be set to maximum when the
+temperature sensor associated with the PWM control exceeds temp#_max.
 
 Notes
 -----
_

Patches currently in -mm which might be from djwong@us.ibm.com are

cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
adt7473-minor-documentation-update.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch

