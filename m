From: akpm@linux-foundation.org
Subject: + crc32-add-help-text-for-the-algorithm-select-option.patch added to -mm tree
Date: Mon, 26 Mar 2012 14:19:47 -0700
Message-ID: <20120326211947.A4968A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36795 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2CZVTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 17:19:49 -0400
Received: by bkcjm19 with SMTP id jm19so291187bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 14:19:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, stefanr@s5r6.in-berlin.de


The patch titled
     Subject: crc32: add help text for the algorithm select option
has been added to the -mm tree.  Its filename is
     crc32-add-help-text-for-the-algorithm-select-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -84,6 +84,10 @@ choice
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
Subject: Subject: crc32: add help text for the algorithm select option

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
crc32-add-help-text-for-the-algorithm-select-option.patch
linux-next.patch

