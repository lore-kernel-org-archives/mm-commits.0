From: akpm@linux-foundation.org
Subject: [patch 128/162] radix-tree: add copyright statements
Date: Fri, 20 May 2016 17:02:58 -0700
Message-ID: <573fa5b2.U3MHONSYLEz4vatf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbcEUAC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: add copyright statements

The multiorder support is a sufficiently large feature to be worth adding
copyrigt lines for.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/radix-tree.c~radix-tree-add-copyright-statements lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-copyright-statements
+++ a/lib/radix-tree.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005 SGI, Christoph Lameter
  * Copyright (C) 2006 Nick Piggin
  * Copyright (C) 2012 Konstantin Khlebnikov
+ * Copyright (C) 2016 Intel, Matthew Wilcox
+ * Copyright (C) 2016 Intel, Ross Zwisler
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
_
