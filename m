From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:48 -0700
Message-ID: <55f31964.U6XjmaX2aYobmnAg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbIKSLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/CREDITS: mark MaxRAID as Orphan, move Anil Ravindranath to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS/CREDITS: mark MaxRAID as Orphan, move Anil Ravindranath to CREDITS

Anil's email address bounces and he hasn't had a signoff
in over 5 years.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN CREDITS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits CREDITS
--- a/CREDITS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits
+++ a/CREDITS
@@ -2992,6 +2992,10 @@ S: 2200 Mission College Blvd
 S: Santa Clara, CA 95052
 S: USA
 
+N: Anil Ravindranath
+E: anil_ravindranath@pmc-sierra.com
+D: PMC-Sierra MaxRAID driver
+
 N: Eric S. Raymond
 E: esr@thyrsus.com
 W: http://www.tuxedo.org/~esr/
diff -puN MAINTAINERS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits
+++ a/MAINTAINERS
@@ -8199,10 +8199,9 @@ F:	drivers/hwmon/pmbus/
 F:	include/linux/i2c/pmbus.h
 
 PMC SIERRA MaxRAID DRIVER
-M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.pmc-sierra.com/
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/pmcraid.*
 
 PMC SIERRA PM8001 DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

