From: akpm@linux-foundation.org
Subject: + mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:09:24 -0800
Message-ID: <201002192109.o1JL9PUo004393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0BSVKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:10:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk


The patch titled
     mptscsih: fix first line of kernel-doc for a few functions
has been added to the -mm tree.  Its filename is
     mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mptscsih: fix first line of kernel-doc for a few functions
From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a short
description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/drivers/message/fusion/mptscsih.c
@@ -2560,9 +2560,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTE
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2725,7 +2723,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 
 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch
video-fix-first-line-of-kernel-doc-for-a-few-functions.patch

