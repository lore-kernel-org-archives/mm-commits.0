Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177F23ABD8D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 03:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898981; cv=none; b=pmJoxMpA+xHyMLZLE3PeMy0Ozk8RxJwFHEfEEDUxc7oOqHxwbS4eIAYgRyuocuKt0IhZXcpdjCC9rrpPBRXjBbIQw37L/Yp9iFnL6VAD1EmLnrz5Q/ml6FQBvwqUGzAh0n7FTZN8uXK7mC2beut6TtYNvqAhFTeUECilHJKd+Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898981; c=relaxed/simple;
	bh=PDl+0dDOGNM32zjpDDSMNKsX/oJBpfEXhB+NsFw2rX8=;
	h=Date:To:From:Subject:Message-Id; b=gjNXyByPKimIYbLYu2G3a64C+gh8/addt4I8DAfJtojVrzwZ2GQgJpGDS2q2oBWcjZCHE+A8PiyrVmJNYS2zrOP3mpdAo/gGLPjbmiJ+lXagcFGWV5ECVEvj0jTIzZ7mr0ywUpQ8ffkW8rp4xt3lIJNQFxdqJ0DfKlqDxG6wmmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JdbNoWtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JdbNoWtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF1E1F000E9;
	Wed,  5 Aug 2026 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898979;
	bh=lKg4XPRrKS5lHXngPjtB95vcwD1+1PYdmrD25rMWJIs=;
	h=Date:To:From:Subject;
	b=JdbNoWtVGE3BJJ+IBK3nNzPgtzpTi78m1ZdersiSPKJ3EbpzVidDUnjI1coYJHCRm
	 TNav3Go2WEfkl6mU6c9hs0UXPm9OPewvJ75ZS9t7kuBs121cabEurDjevouROKFVQH
	 oDeFQ/RR2faRdWx1Zj1oP4+UvuJ5PWu/Cb88uP/Q=
Date: Tue, 04 Aug 2026 20:02:58 -0700
To: mm-commits@vger.kernel.org,kuba@kernel.org,danila@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-old-addresses-to-danila-tikhonov.patch removed from -mm tree
Message-Id: <20260805030259.7DF1E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: map old addresses to Danila Tikhonov
has been removed from the -mm tree.  Its filename was
     mailmap-map-old-addresses-to-danila-tikhonov.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Danila Tikhonov <danila@mainlining.org>
Subject: mailmap: map old addresses to Danila Tikhonov
Date: Sat, 1 Aug 2026 18:33:33 +0300

Map my old jiaxyga.com and ProtonMail addresses to the current
mainlining.org address.

Link: https://lore.kernel.org/20260801153333.296218-1-danila@mainlining.org
Signed-off-by: Danila Tikhonov <danila@mainlining.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-map-old-addresses-to-danila-tikhonov
+++ a/.mailmap
@@ -233,6 +233,8 @@ Daniel Lezcano <daniel.lezcano@kernel.or
 Daniel Lezcano <daniel.lezcano@kernel.org> <dlezcano@fr.ibm.com>
 Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
 Daniele Alessandrelli <daniele.alessandrelli@gmail.com> <daniele.alessandrelli@intel.com>
+Danila Tikhonov <danila@mainlining.org> <danila@jiaxyga.com>
+Danila Tikhonov <danila@mainlining.org> <JIaxyga@protonmail.com>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from danila@mainlining.org are


