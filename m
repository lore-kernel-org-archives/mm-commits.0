From: akpm@linux-foundation.org
Subject: [to-be-updated] ocfs2-update-filecheck-copyright.patch removed
 from -mm tree
Date: Mon, 31 Aug 2015 14:41:10 -0700
Message-ID: <55e4c9f6.23GH60pYn8RmgjQl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbbHaVlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 17:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: update filecheck copyright
has been removed from the -mm tree.  Its filename was
     ocfs2-update-filecheck-copyright.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: update filecheck copyright

Besides inode block online check, add file extent block online check this
time, we will add more kinds of meta block online check/repair in the
future.


This patch (of 4):

Update filecheck copyright to the right time/contributor

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    2 +-
 fs/ocfs2/filecheck.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-update-filecheck-copyright fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-update-filecheck-copyright
+++ a/fs/ocfs2/filecheck.c
@@ -5,7 +5,7 @@
  *
  * Code which implements online file check.
  *
- * Copyright (C) 2007, 2009 Oracle.  All rights reserved.
+ * Copyright (C) 2015 Novell.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
diff -puN fs/ocfs2/filecheck.h~ocfs2-update-filecheck-copyright fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-update-filecheck-copyright
+++ a/fs/ocfs2/filecheck.h
@@ -5,7 +5,7 @@
  *
  * Online file check.
  *
- * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2015 Novell.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-add-errno-and-macro-definitions.patch
ocfs2-filecheck-validate_extent_block-function.patch
ocfs2-add-file-extent-block-check.patch

