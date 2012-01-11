From: akpm@linux-foundation.org
Subject: [obsolete] scsi-fix-a-header-to-include-linux-typesh.patch removed from -mm tree
Date: Tue, 10 Jan 2012 16:08:27 -0800
Message-ID: <20120111000828.784EC5C00B4@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52091 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2AKAIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 19:08:30 -0500
Received: by werf1 with SMTP id f1so5848wer.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 16:08:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: virtuoso@slind.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fix a header to include linux/types.h
has been removed from the -mm tree.  Its filename was
     scsi-fix-a-header-to-include-linux-typesh.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexander Shishkin <virtuoso@slind.org>
Subject: scsi: fix a header to include linux/types.h

For headers that get exported to userland and make use of u32 style
type names, it is advised to include linux/types.h.

This fixes a headers_check warning.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_netlink.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/scsi/scsi_netlink.h~scsi-fix-a-header-to-include-linux-typesh include/scsi/scsi_netlink.h
--- a/include/scsi/scsi_netlink.h~scsi-fix-a-header-to-include-linux-typesh
+++ a/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
