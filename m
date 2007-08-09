From: akpm@linux-foundation.org
Subject: + readahead-docbook-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:52:20 -0700
Message-ID: <200708092152.l79LqKql021373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbXHIVw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:52:27 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l79LqPCH028167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 9 Aug 2007 14:52:26 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     readahead: docbook fix
has been added to the -mm tree.  Its filename is
     readahead-docbook-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: docbook fix
From: Stephen Hemminger <shemminger@linux-foundation.org>

Minor docbook error since argument name in comment doesn't match function

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-docbook-fix mm/filemap.c
--- a/mm/filemap.c~readahead-docbook-fix
+++ a/mm/filemap.c
@@ -843,7 +843,7 @@ static void shrink_readahead_size_eio(st
 /**
  * do_generic_mapping_read - generic file read routine
  * @mapping:	address_space to be read
- * @ra:		file's readahead state
+ * @_ra:	file's readahead state
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

readahead-docbook-fix.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
fib_trie-cleanup.patch
fib_trie-cleanup-fix.patch
fib_trie-macro-cleanup.patch
git-wireless.patch
