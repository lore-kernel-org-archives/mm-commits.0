From: akpm@linux-foundation.org
Subject: [merged] crc32-add-note-about-this-patchset-to-crc32c.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:52 -0700
Message-ID: <20120326193052.587D6A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59625 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:53 -0400
Received: by qcsp5 with SMTP id p5so513850qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpearson@systemfabricworks.com, djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: add note about this patchset to crc32.c
has been removed from the -mm tree.  Its filename was
     crc32-add-note-about-this-patchset-to-crc32c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Pearson <rpearson@systemfabricworks.com>
Subject: crc32: add note about this patchset to crc32.c

Add a comment at the top of crc32.c

[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/crc32.c~crc32-add-note-about-this-patchset-to-crc32c lib/crc32.c
--- a/lib/crc32.c~crc32-add-note-about-this-patchset-to-crc32c
+++ a/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was
_

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch

