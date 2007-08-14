From: akpm@linux-foundation.org
Subject: - readahead-docbook-fix.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:53 -0700
Message-ID: <200708140503.l7E53r2Y032102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759650AbXHNFKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:10:47 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7E5AIht021278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 13 Aug 2007 22:10:19 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     readahead: docbook fix
has been removed from the -mm tree.  Its filename was
     readahead-docbook-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-avr32.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
git-net.patch
fib_trie-cleanup.patch
fib_trie-macro-cleanup.patch
