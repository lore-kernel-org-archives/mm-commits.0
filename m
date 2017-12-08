From: akpm@linux-foundation.org
Subject: + tools-slabinfo-gnuplot-force-to-use-bash-shell.patch added to
 -mm tree
Date: Fri, 08 Dec 2017 13:57:23 -0800
Message-ID: <5a2b0ac3.TaFT8JOsDCEzn9vu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39608 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdLHV5Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 16:57:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changcheng.liu@intel.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/slabinfo-gnuplot: force to use bash shell
has been added to the -mm tree.  Its filename is
     tools-slabinfo-gnuplot-force-to-use-bash-shell.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-slabinfo-gnuplot-force-to-use-bash-shell.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-slabinfo-gnuplot-force-to-use-bash-shell.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: tools/slabinfo-gnuplot: force to use bash shell

On some linux distributions, the default link of sh
is dash which deoesn't support split array like
${var//,/ }
It's better to force to use bash shell directly.

Link: http://lkml.kernel.org/r/20171208093751.GA175471@sofia
Signed-off-by: Liu Changcheng <changcheng.liu@intel.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo-gnuplot.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/slabinfo-gnuplot.sh~tools-slabinfo-gnuplot-force-to-use-bash-shell tools/vm/slabinfo-gnuplot.sh
--- a/tools/vm/slabinfo-gnuplot.sh~tools-slabinfo-gnuplot-force-to-use-bash-shell
+++ a/tools/vm/slabinfo-gnuplot.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # Sergey Senozhatsky, 2015
 # sergey.senozhatsky.work@gmail.com
_

Patches currently in -mm which might be from changcheng.liu@intel.com are

scripts-faddr2line-fix-cross_compile-unset-error.patch
tools-slabinfo-gnuplot-force-to-use-bash-shell.patch

