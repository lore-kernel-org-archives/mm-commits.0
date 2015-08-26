From: akpm@linux-foundation.org
Subject: + ocfs2-update-filecheck-copyright.patch added to -mm tree
Date: Wed, 26 Aug 2015 11:25:28 -0700
Message-ID: <55de0498.LCuA3JaEpr0Vw8xy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbHZSZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Aug 2015 14:25:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: update filecheck copyright
has been added to the -mm tree.  Its filename is
     ocfs2-update-filecheck-copyright.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-update-filecheck-copyright.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-update-filecheck-copyright.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch
ocfs2-add-feature-document-for-online-file-check.patch
ocfs2-update-filecheck-copyright.patch
ocfs2-add-errno-and-macro-definitions.patch
ocfs2-filecheck-validate_extent_block-function.patch
ocfs2-add-file-extent-block-check.patch

