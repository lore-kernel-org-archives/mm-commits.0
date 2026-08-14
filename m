Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E2F298CAB
	for <mm-commits@vger.kernel.org>; Fri, 14 Aug 2026 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669718; cv=none; b=lEDby9e3e+anJewaL/irhOieINOG8DTKpaOL2hxT6lSFCOf5+U0Yb4SEl5Gzn4OdsfCSyzc3oH46adpxlUYrmR4PdYeWxiyH6/oIUjfaKfKv9DpEpohpkJUjrvCKQMY2LEiA9DoMqW99CVRih0h7Uw8gAGcJkCsSJ0RMbxodtZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669718; c=relaxed/simple;
	bh=8H7rlLn8v06QXnkPsSHE4uCaH3NYOS1Stb09B3G2ygw=;
	h=Date:To:From:Subject:Message-Id; b=DC7Bt1tEIUIa1xtG0qEnxSMFThQcJk2s3p/AMooQKOapemH2+SCRBhhh54JUpBnYM33d+EHjLqrdkVdhT+mBwt/EbYTv/ZMnmaC6BGgAfjZlSIjHMirVpmMxw0duvOI9Q5se3nC2fLZH2H+5KguxTVwnnVtP0XGx9osVgAEgQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POiR/ezK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POiR/ezK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643821F000E9;
	Fri, 14 Aug 2026 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669716;
	bh=ru2ik45KpTPlU4HHpQS6eSaSCbn0y8Zb8XJu+AUtg0c=;
	h=Date:To:From:Subject;
	b=POiR/ezKUrRmNtSeorP9Bx9GxvhfjzJF9lcCkgTBt3pGuzPIqD+UZjrYvTKmSy2QQ
	 I7dxetP0dr6JfGm5yFGMNxiPP4V7/AtR7K8Z2QE8UbZb+VNJNXVOxlwLlgf8THUfPl
	 8NGHr8PwyhlDSL6Oh/UMYCAxrNf95IEWJCS0ICIM=
Date: Thu, 13 Aug 2026 18:08:35 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-email-address-for-jp-kobryn.patch removed from -mm tree
Message-Id: <20260814010836.643821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: update email address for JP Kobryn
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-email-address-for-jp-kobryn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


