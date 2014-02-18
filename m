From: akpm@linux-foundation.org
Subject: + ncpfs-cleanup-indenting-in-ncp_lookup.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:43:22 -0800
Message-ID: <5303d3fa.GYhKiqaSuzChbZNi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaBRVnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, chiluk@canonical.com, dan.carpenter@oracle.com

Subject: + ncpfs-cleanup-indenting-in-ncp_lookup.patch added to -mm tree
To: dan.carpenter@oracle.com,chiluk@canonical.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:43:22 -0800


The patch titled
     Subject: fs/ncpfs/dir.c: fix indenting in ncp_lookup()
has been added to the -mm tree.  Its filename is
     ncpfs-cleanup-indenting-in-ncp_lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-cleanup-indenting-in-ncp_lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-cleanup-indenting-in-ncp_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: fs/ncpfs/dir.c: fix indenting in ncp_lookup()

My static checker suggests adding curly braces here.  Probably that was
the intent, but actually the code works the same either way.  I've just
changed the indenting and left the code as-is.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: Dave Chiluk <chiluk@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/dir.c~ncpfs-cleanup-indenting-in-ncp_lookup fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~ncpfs-cleanup-indenting-in-ncp_lookup
+++ a/fs/ncpfs/dir.c
@@ -849,8 +849,8 @@ static struct dentry *ncp_lookup(struct
 				 dentry->d_name.len, 1);
 		if (!res)
 			res = ncp_lookup_volume(server, __name, &(finfo.i));
-			if (!res)
-				ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
+		if (!res)
+			ncp_update_known_namespace(server, finfo.i.volNumber, NULL);
 	} else {
 		res = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 				 dentry->d_name.len, !ncp_preserve_case(dir));
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
ncpfs-cleanup-indenting-in-ncp_lookup.patch
drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
linux-next.patch

