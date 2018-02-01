From: akpm@linux-foundation.org
Subject: [folded-merged]
 tools-vm-new-option-to-specify-kpageflags-file-fix.patch removed from -mm
 tree
Date: Wed, 31 Jan 2018 16:07:48 -0800
Message-ID: <5a725a54.TWYQi558kLulwQIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754675AbeBAAHu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools-vm-new-option-to-specify-kpageflags-file-fix
has been removed from the -mm tree.  Its filename was
     tools-vm-new-option-to-specify-kpageflags-file-fix.patch

This patch was dropped because it was folded into tools-vm-new-option-to-specify-kpageflags-file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-vm-new-option-to-specify-kpageflags-file-fix

add "filename" to fix usage() string

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file-fix tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file-fix
+++ a/tools/vm/page-types.c
@@ -791,7 +791,7 @@ static void usage(void)
 "            -N|--no-summary            Don't show summary info\n"
 "            -X|--hwpoison              hwpoison pages\n"
 "            -x|--unpoison              unpoison pages\n"
-"            -F|--kpageflags            kpageflags file to parse\n"
+"            -F|--kpageflags filename   kpageflags file to parse\n"
 "            -h|--help                  Show this usage message\n"
 "flags:\n"
 "            0x10                       bitfield format, e.g.\n"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
tools-vm-new-option-to-specify-kpageflags-file.patch

