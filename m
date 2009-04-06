From: akpm@linux-foundation.org
Subject: [merged] if-0-ses_match_host.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:08 -0700
Message-ID: <200904061939.n36Jd8kc013703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbZDFT7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     #if 0 ses_match_host()
has been removed from the -mm tree.  Its filename was
     if-0-ses_match_host.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: #if 0 ses_match_host()
From: Adrian Bunk <bunk@kernel.org>

#if 0 the unused ses_match_host()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ses.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/ses.c~if-0-ses_match_host drivers/scsi/ses.c
--- a/drivers/scsi/ses.c~if-0-ses_match_host
+++ a/drivers/scsi/ses.c
@@ -264,6 +264,7 @@ struct ses_host_edev {
 	struct enclosure_device *edev;
 };
 
+#if 0
 int ses_match_host(struct enclosure_device *edev, void *data)
 {
 	struct ses_host_edev *sed = data;
@@ -280,6 +281,7 @@ int ses_match_host(struct enclosure_devi
 	sed->edev = edev;
 	return 1;
 }
+#endif  /*  0  */
 
 static void ses_process_descriptor(struct enclosure_component *ecomp,
 				   unsigned char *desc)
_

Patches currently in -mm which might be from bunk@kernel.org are

frv-fix-compile-breakage.patch
linux-next.patch
reiser4.patch

