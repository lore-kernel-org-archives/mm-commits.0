From: akpm@linux-foundation.org
Subject: [merged] crc32-add-help-text-for-the-algorithm-select-option.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:30 -0700
Message-ID: <20120329191430.66AA2A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61916 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764Ab2C2TOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:31 -0400
Received: by vbnl22 with SMTP id l22so296290vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: add help text for the algorithm select option
has been removed from the -mm tree.  Its filename was
     crc32-add-help-text-for-the-algorithm-select-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: crc32: add help text for the algorithm select option

Add help text to the crc32 algorithm selection option in Kconfig.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/Kconfig~crc32-add-help-text-for-the-algorithm-select-option lib/Kconfig
--- a/lib/Kconfig~crc32-add-help-text-for-the-algorithm-select-option
+++ a/lib/Kconfig
@@ -88,6 +88,10 @@ choice
 	prompt "CRC32 implementation"
 	depends on CRC32
 	default CRC32_SLICEBY8
+	help
+	  This option allows a kernel builder to override the default choice
+	  of CRC32 algorithm.  Choose the default ("slice by 8") unless you
+	  know that you need one of the others.
 
 config CRC32_SLICEBY8
 	bool "Slice by 8 bytes"
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch

