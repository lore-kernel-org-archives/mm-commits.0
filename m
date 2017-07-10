From: akpm@linux-foundation.org
Subject: [patch 083/115] MAINTAINERS: give proc sysctl some
 maintainer love
Date: Mon, 10 Jul 2017 15:51:23 -0700
Message-ID: <20170710225123.15qTEptef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43324 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754867AbdGJWvY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -10559,6 +10559,17 @@ W:	http://wireless.kernel.org/en/users/D
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
