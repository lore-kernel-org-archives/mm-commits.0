From: akpm@linux-foundation.org
Subject: + i2o-remove-markus-from-maintainers.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:24:18 -0700
Message-ID: <200703262224.l2QMOI3p032122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933347AbXCZWYn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Markus.Lidel@shadowconnect.com


The patch titled
     I2O: remove Markus from MAINTAINERS
has been added to the -mm tree.  Its filename is
     i2o-remove-markus-from-maintainers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I2O: remove Markus from MAINTAINERS
From: Markus Lidel <Markus.Lidel@shadowconnect.com>

Because i don't have much time lately and my responses are pretty slow
it's probably best to remove me from MAINTAINERS to give someone else
the chance to jump in.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 files changed, 6 deletions(-)

diff -puN MAINTAINERS~i2o-remove-markus-from-maintainers MAINTAINERS
--- a/MAINTAINERS~i2o-remove-markus-from-maintainers
+++ a/MAINTAINERS
@@ -1656,12 +1656,6 @@ L:	i2c@lm-sensors.org
 T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
 S:	Maintained
 
-I2O
-P:	Markus Lidel
-M:	markus.lidel@shadowconnect.com
-W:	http://i2o.shadowconnect.com/
-S:	Maintained
-
 i386 BOOT CODE
 P:	Riley H. Williams
 M:	Riley@Williams.Name
_

Patches currently in -mm which might be from Markus.Lidel@shadowconnect.com are

block-io-errors-on-i2o-disk.patch
i2o-remove-markus-from-maintainers.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
