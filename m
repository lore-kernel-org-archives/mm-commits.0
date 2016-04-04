From: akpm@linux-foundation.org
Subject: + lib-uuid-remove-fsf-address.patch added to -mm tree
Date: Mon, 04 Apr 2016 16:40:52 -0700
Message-ID: <5702fb84.vp9BZWx4MMwZjfKm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495AbcDDXk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 19:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/uuid: remove FSF address
has been added to the -mm tree.  Its filename is
     lib-uuid-remove-fsf-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-uuid-remove-fsf-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-uuid-remove-fsf-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/uuid: remove FSF address

There is no point to keep an address in the file since it's a subject to
change.

While here, update Intel Copyright years.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uuid.h      |    6 +-----
 include/uapi/linux/uuid.h |    4 ----
 lib/uuid.c                |    6 +-----
 3 files changed, 2 insertions(+), 14 deletions(-)

diff -puN include/linux/uuid.h~lib-uuid-remove-fsf-address include/linux/uuid.h
--- a/include/linux/uuid.h~lib-uuid-remove-fsf-address
+++ a/include/linux/uuid.h
@@ -1,7 +1,7 @@
 /*
  * UUID/GUID definition
  *
- * Copyright (C) 2010, Intel Corp.
+ * Copyright (C) 2010, 2016 Intel Corp.
  *	Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #ifndef _LINUX_UUID_H_
 #define _LINUX_UUID_H_
diff -puN include/uapi/linux/uuid.h~lib-uuid-remove-fsf-address include/uapi/linux/uuid.h
--- a/include/uapi/linux/uuid.h~lib-uuid-remove-fsf-address
+++ a/include/uapi/linux/uuid.h
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef _UAPI_LINUX_UUID_H_
diff -puN lib/uuid.c~lib-uuid-remove-fsf-address lib/uuid.c
--- a/lib/uuid.c~lib-uuid-remove-fsf-address
+++ a/lib/uuid.c
@@ -1,7 +1,7 @@
 /*
  * Unified UUID/GUID definition
  *
- * Copyright (C) 2009, Intel Corp.
+ * Copyright (C) 2009, 2015 Intel Corp.
  *	Huang Ying <ying.huang@intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-simplify-uuid-printing.patch
lib-uuid-move-generate_random_uuid-to-uuidc.patch
lib-uuid-introduce-few-more-generic-helpers-for-uuid.patch
lib-uuid-remove-fsf-address.patch
sysctl-drop-away-useless-label.patch
sysctl-use-generic-uuid-library.patch
efi-redefine-type-constant-macro-from-generic-code.patch
efivars-use-generic-uuid-library.patch

