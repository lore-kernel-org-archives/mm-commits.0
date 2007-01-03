From: akpm@osdl.org
Subject: - fix-typo-in-i2c-smbus-documentation.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:20:40 -0800
Message-ID: <200701032220.l03MKefK000740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55567 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbXACWUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fix typo in i2c smbus documentation
has been removed from the -mm tree.  Its filename was
     fix-typo-in-i2c-smbus-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix typo in i2c smbus documentation
From: "Mike Frysinger" <vapier.adi@gmail.com>

Fix typo in SMBus Write Word Data description (write data, dont read it).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/i2c/smbus-protocol |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/i2c/smbus-protocol~fix-typo-in-i2c-smbus-documentation Documentation/i2c/smbus-protocol
--- a/Documentation/i2c/smbus-protocol~fix-typo-in-i2c-smbus-documentation
+++ a/Documentation/i2c/smbus-protocol
@@ -97,7 +97,7 @@ SMBus Write Word Data
 =====================
 
 This is the opposite operation of the Read Word Data command. 16 bits
-of data is read from a device, from a designated register that is 
+of data is written to a device to the designated register that is 
 specified through the Comm byte. 
 
 S Addr Wr [A] Comm [A] DataLow [A] DataHigh [A] P
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

search-a-little-harder-for-mkimage.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
