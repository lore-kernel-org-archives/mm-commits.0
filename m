From: akpm@linux-foundation.org
Subject: + feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:16:57 -0700
Message-ID: <200808052016.m75KGvgn021219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764340AbYHEURQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@HansenPartnership.com, hch@lst.de


The patch titled
     feature-removal-schedule.txt: remove the NCR53C9x entry
has been added to the -mm tree.  Its filename is
     feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch

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
Subject: feature-removal-schedule.txt: remove the NCR53C9x entry
From: Adrian Bunk <bunk@kernel.org>

Now that the driver is removed we should also remove the entry in
Documentation/feature-removal-schedule.txt

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~feature-removal-scheduletxt-remove-the-ncr53c9x-entry Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~feature-removal-scheduletxt-remove-the-ncr53c9x-entry
+++ a/Documentation/feature-removal-schedule.txt
@@ -19,15 +19,6 @@ Who:	Pavel Machek <pavel@suse.cz>
 
 ---------------------------
 
-What:	old NCR53C9x driver
-When:	October 2007
-Why:	Replaced by the much better esp_scsi driver.  Actual low-level
-	driver can be ported over almost trivially.
-Who:	David Miller <davem@davemloft.net>
-	Christoph Hellwig <hch@lst.de>
-
----------------------------
