Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650E24582DD
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139974; cv=none; b=DoduPxvyvIMmuLqpU+Qh+FB0BrOx3O0eYDlY5lZeYjipjoVi1L37qdF8mVBCg9cupAOPd75AAtplhXYh7IXRREwS36Sctz3Xq41TkOLtWeydYVBBQ2T10TKiIK/JKBCpexGKhOJ4c4yTZF2k763qSkThboKLWRwd6p4w5/MGx/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139974; c=relaxed/simple;
	bh=hNSWo+S9GV86OISYf2izN1H+USBkFWdVzglFeY8LbpA=;
	h=Date:To:From:Subject:Message-Id; b=Wk77XZblqXcaPKhWrfv9ZByzS4kgmwKSoSRB7WvEO4V7W/V73Ahthb3x2f7ySc09cd8vJbP0Bu/VEPlhmUHQwm33bAybJb7kiJw++fB794nHqyR5N+qbPlRf31o42inx8hZ5SwYBwdwf6pqmPTl7qIPHG4Ls7p4Ki+RP3IzC5YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RqIkbdDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RqIkbdDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB781F000E9;
	Fri,  7 Aug 2026 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786139973;
	bh=1x0szWi/0NAVZ5a+36DYpXOzGwx7JxvkmzwOxctFEz8=;
	h=Date:To:From:Subject;
	b=RqIkbdDESY6JFrbrRtqH0WXfTj2504Ez0jXmfrSPEhpDQzGKGnmJMJgYrWGlA8osv
	 ZohS5T7lo8YJYmDlZdlz/9EAda+Sc5Qya858VIYiJodRqh0rtH6G/PoXOsBRnkhgI+
	 nQjs5fk5phdCB0LXVqG+Y4T4hhqCd2iRQn/ZUTGI=
Date: Fri, 07 Aug 2026 14:59:32 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-email-address-for-jp-kobryn.patch added to mm-hotfixes-unstable branch
Message-Id: <20260807215932.DDB781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: update email address for JP Kobryn
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-email-address-for-jp-kobryn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-email-address-for-jp-kobryn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: MAINTAINERS, mailmap: update email address for JP Kobryn
Date: Thu, 6 Aug 2026 18:02:26 -0700

Switch to my linux.dev address and add previous one to mailmap.

Link: https://lore.kernel.org/20260807010226.8995-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-jp-kobryn
+++ a/.mailmap
@@ -459,6 +459,7 @@ Jorge Ramirez-Ortiz <jorge.ramirez@oss.q
 Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@redhat.com>
 Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@us.ibm.com>
 Jouni Malinen <quic_jouni@quicinc.com> <jouni@codeaurora.org>
+JP Kobryn <jp.kobryn@linux.dev> <inwardvessel@gmail.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-jp-kobryn
+++ a/MAINTAINERS
@@ -4982,7 +4982,7 @@ F:	tools/lib/bpf/
 
 BPF [MEMORY MANAGEMENT EXTENSIONS]
 M:	Roman Gushchin <roman.gushchin@linux.dev>
-M:	JP Kobryn <inwardvessel@gmail.com>
+M:	JP Kobryn <jp.kobryn@linux.dev>
 M:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

maintainers-mailmap-update-email-address-for-jp-kobryn.patch

