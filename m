From: akpm@linux-foundation.org
Subject: + page-types-whitespace-alignment.patch added to -mm tree
Date: Tue, 10 Nov 2009 15:54:30 -0800
Message-ID: <200911102354.nAANsUAD029841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186AbZKJXy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 18:54:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, fengguang.wu@intel.com


The patch titled
     page-types: whitespace alignment
has been added to the -mm tree.  Its filename is
     page-types-whitespace-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: whitespace alignment
From: Alex Chiang <achiang@hp.com>

Align the output when page-type -h is invoked.

Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-whitespace-alignment Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-whitespace-alignment
+++ a/Documentation/vm/page-types.c
@@ -673,35 +673,35 @@ static void usage(void)
 
 	printf(
 "page-types [options]\n"
-"            -r|--raw                  Raw mode, for kernel developers\n"
+"            -r|--raw                   Raw mode, for kernel developers\n"
 "            -d|--describe flags        Describe flags\n"
-"            -a|--addr    addr-spec    Walk a range of pages\n"
-"            -b|--bits    bits-spec    Walk pages with specified bits\n"
-"            -p|--pid     pid          Walk process address space\n"
+"            -a|--addr    addr-spec     Walk a range of pages\n"
+"            -b|--bits    bits-spec     Walk pages with specified bits\n"
+"            -p|--pid     pid           Walk process address space\n"
 #if 0 /* planned features */
-"            -f|--file    filename     Walk file address space\n"
+"            -f|--file    filename      Walk file address space\n"
 #endif
-"            -l|--list                 Show page details in ranges\n"
-"            -L|--list-each            Show page details one by one\n"
-"            -N|--no-summary           Don't show summary info\n"
-"            -X|--hwpoison             hwpoison pages\n"
-"            -x|--unpoison             unpoison pages\n"
-"            -h|--help                 Show this usage message\n"
+"            -l|--list                  Show page details in ranges\n"
+"            -L|--list-each             Show page details one by one\n"
+"            -N|--no-summary            Don't show summary info\n"
+"            -X|--hwpoison              hwpoison pages\n"
+"            -x|--unpoison              unpoison pages\n"
+"            -h|--help                  Show this usage message\n"
 "flags:\n"
-"            0x10                      bitfield format, e.g.\n"
-"            anon                      bit-name, e.g.\n"
-"            0x10,anon                 comma-separated list, e.g.\n"
+"            0x10                       bitfield format, e.g.\n"
+"            anon                       bit-name, e.g.\n"
+"            0x10,anon                  comma-separated list, e.g.\n"
 "addr-spec:\n"
-"            N                         one page at offset N (unit: pages)\n"
-"            N+M                       pages range from N to N+M-1\n"
-"            N,M                       pages range from N to M-1\n"
-"            N,                        pages range from N to end\n"
-"            ,M                        pages range from 0 to M-1\n"
+"            N                          one page at offset N (unit: pages)\n"
+"            N+M                        pages range from N to N+M-1\n"
+"            N,M                        pages range from N to M-1\n"
+"            N,                         pages range from N to end\n"
+"            ,M                         pages range from 0 to M-1\n"
 "bits-spec:\n"
-"            bit1,bit2                 (flags & (bit1|bit2)) != 0\n"
-"            bit1,bit2=bit1            (flags & (bit1|bit2)) == bit1\n"
-"            bit1,~bit2                (flags & (bit1|bit2)) == bit1\n"
-"            =bit1,bit2                flags == (bit1|bit2)\n"
+"            bit1,bit2                  (flags & (bit1|bit2)) != 0\n"
+"            bit1,bit2=bit1             (flags & (bit1|bit2)) == bit1\n"
+"            bit1,~bit2                 (flags & (bit1|bit2)) == bit1\n"
+"            =bit1,bit2                 flags == (bit1|bit2)\n"
 "bit-names:\n"
 	);
 
_

Patches currently in -mm which might be from achiang@hp.com are

linux-next.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch

