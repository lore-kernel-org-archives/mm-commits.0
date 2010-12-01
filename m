From: akpm@linux-foundation.org
Subject: + scsi-fix-a-header-to-include-linux-typesh.patch added to -mm tree
Date: Wed, 01 Dec 2010 14:52:27 -0800
Message-ID: <201012012252.oB1MqRIA016489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab0LAWwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 17:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: virtuoso@slind.org, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix a header to include linux/types.h
has been added to the -mm tree.  Its filename is
     scsi-fix-a-header-to-include-linux-typesh.patch

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
Subject: scsi: fix a header to include linux/types.h
From: Alexander Shishkin <virtuoso@slind.org>

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
