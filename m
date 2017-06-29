From: akpm@linux-foundation.org
Subject: + maintainers-give-kmod-some-maintainer-love.patch added to -mm
 tree
Date: Thu, 29 Jun 2017 14:52:06 -0700
Message-ID: <59557686.bzsNk12SYM2Rwuvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdF2VwH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, gregkh@linuxfoundation.org, jeyu@redhat.com, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: give kmod some maintainer love
has been added to the -mm tree.  Its filename is
     maintainers-give-kmod-some-maintainer-love.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-give-kmod-some-maintainer-love.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-give-kmod-some-maintainer-love.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: MAINTAINERS: give kmod some maintainer love

As suggested by Jessica, I've been actively working on kmod, so
might as well reflect its maintained status.

Changes are expected to go through akpm's tree.

Link: http://lkml.kernel.org/r/20170628223155.26472-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Suggested-by: Jessica Yu <jeyu@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-give-kmod-some-maintainer-love MAINTAINERS
--- a/MAINTAINERS~maintainers-give-kmod-some-maintainer-love
+++ a/MAINTAINERS
@@ -7564,6 +7564,13 @@ F:	include/linux/kmemleak.h
 F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
+KMOD MODULE USERMODE HELPER
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	kernel/kmod.c
+F:	include/linux/kmod.h
+
 KPROBES
 M:	Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
 M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-give-proc-sysctl-some-maintainer-love.patch
sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch
test_sysctl-add-dedicated-proc-sysctl-test-driver.patch
maintainers-give-kmod-some-maintainer-love.patch
kmod-add-test-driver-to-stress-test-the-module-loader.patch
kmod-throttle-kmod-thread-limit.patch

