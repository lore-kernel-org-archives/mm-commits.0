From: akpm@linux-foundation.org
Subject: + maintainers-give-proc-sysctl-some-maintainer-love.patch added
 to -mm tree
Date: Thu, 25 May 2017 16:25:02 -0700
Message-ID: <592767ce.3MRMVuMDP0yuCZvE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbdEYXZD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:25:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: give proc sysctl some maintainer love
has been added to the -mm tree.  Its filename is
     maintainers-give-proc-sysctl-some-maintainer-love.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-give-proc-sysctl-some-maintainer-love.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-give-proc-sysctl-some-maintainer-love.patch

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
Subject: MAINTAINERS: give proc sysctl some maintainer love

We poke at proc sysctl enough that really we should declare it maintained.
We'll just be Cc'd and sending updates / ACK'ing changes through akpm's
tree.

Link: http://lkml.kernel.org/r/20170524231305.8649-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~maintainers-give-proc-sysctl-some-maintainer-love MAINTAINERS
--- a/MAINTAINERS~maintainers-give-proc-sysctl-some-maintainer-love
+++ a/MAINTAINERS
@@ -10284,6 +10284,17 @@ W:	http://wireless.kernel.org/en/users/D
 S:	Obsolete
 F:	drivers/net/wireless/intersil/prism54/
 
+PROC SYSCTL
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
+M:	Kees Cook <keescook@chromium.org>
+L:	linux-kernel@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	fs/proc/proc_sysctl.c
+F:	include/linux/sysctl.h
+F:	kernel/sysctl.c
+F:	tools/testing/selftests/sysctl/
+
 PS3 NETWORK SUPPORT
 M:	Geoff Levand <geoff@infradead.org>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from mcgrof@kernel.org are

maintainers-give-proc-sysctl-some-maintainer-love.patch
sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch

