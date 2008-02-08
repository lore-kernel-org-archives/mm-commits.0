From: akpm@linux-foundation.org
Subject: - change-udf-maintainer.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:57 -0800
Message-ID: <200802082017.m18KHcB2010843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbYBHUq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, bfennema@falcon.csc.calpoly.edu, mm-commits@vger.kernel.org


The patch titled
     udf: change maintainer
has been removed from the -mm tree.  Its filename was
     change-udf-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: change maintainer
From: Jan Kara <jack@suse.cz>
DESC
udf: change maintainer
eDESC

I've tried to contact Ben Fennema a few times but without success.  Since I'm
currently probably closest to being an UDF maintainer, I guess it's fine to
also change the entry in MAINTAINERS.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <bfennema@falcon.csc.calpoly.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~change-udf-maintainer MAINTAINERS
--- a/MAINTAINERS~change-udf-maintainer
+++ a/MAINTAINERS
@@ -3895,8 +3895,8 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 UDF FILESYSTEM
-P:	Ben Fennema
-M:	bfennema@falcon.csc.calpoly.edu
+P:	Jan Kara
+M:	jack@suse.cz
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
