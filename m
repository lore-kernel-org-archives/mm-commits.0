From: akpm@linux-foundation.org
Subject: - adt7473-minor-documentation-update.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:28 -0700
Message-ID: <200805132133.m4DLXSNm000826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762169AbYEMVeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt7473: minor documentation update
has been removed from the -mm tree.  Its filename was
     adt7473-minor-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7473: minor documentation update
From: "Darrick J. Wong" <djwong@us.ibm.com>

Add a sentence about when fan speed increases to maximum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
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

origin.patch
i5k_amb-support-intel-5400-chipset.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms.patch
ibmaem-overview-of-the-driver.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch

