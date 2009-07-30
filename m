From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-pps-patterns.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:56 -0700
Message-ID: <200907302037.n6UKbugZ012217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbZG3Ui2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Add PPS patterns
has been removed from the -mm tree.  Its filename was
     maintainers-add-pps-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Add PPS patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~maintainers-add-pps-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-add-pps-patterns
+++ a/MAINTAINERS
@@ -4667,6 +4667,9 @@ M:	giometti@enneenne.com
 W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
 L:	linuxpps@ml.enneenne.com (subscribers-only)
 S:	Maintained
+F:	Documentation/pps/
+F:	drivers/pps/
+F:	include/linux/pps*.h
 
 PREEMPTIBLE KERNEL
 P:	Robert Love
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

