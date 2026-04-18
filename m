Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC9D34F48E
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499197; cv=none; b=YKPqvd2iLJR/TVhcV+tiLWzu3ORtTS6qGTewaSuzhCFbNjxfYeH39r4jfn3+wL+28voLH4Y45mfnvumQ3LHlJo+nxqlClnlpJ3hZmAd07qdxZmGggYbsghBb18i4YDQ37+Tx8Zwx6E4dO1RQZgnsyBqcwh2Te11V6143rtSDPNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499197; c=relaxed/simple;
	bh=LZ/sL1zZTaCnEyQk6pFVFkNtBzoAO35BEVdB3BygyZg=;
	h=Date:To:From:Subject:Message-Id; b=FQOHmBGTIieDbMXD1DMwPAsYWsyOHv/NlhvrV3X5IvA71+G48zsOr97qR+JNa6PEOlT7GP3gdpEmBG4Y1DEQ+vATHScysDNvqeDG1UpjBvlgTkoTjX2y+9UQTX93phsSATIX68m9WwSMm/mAKLGLmI8l8EXCKdEIhulAfdAQ9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ayhgNhJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayhgNhJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABC2C19424;
	Sat, 18 Apr 2026 07:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499197;
	bh=LZ/sL1zZTaCnEyQk6pFVFkNtBzoAO35BEVdB3BygyZg=;
	h=Date:To:From:Subject:From;
	b=ayhgNhJt9lt5QcMf2H5LhK8z5+d3kb/5iWKdxHQkmvWB2JJuirLGKU31P5EGBw9m2
	 tKr6r96/wOJTCz3bgCGa1CeljmiiXWyJfpnAmYQGJDNyLVtMc/9oku+Bf8yB5AKhIC
	 HCjnX+1WmQjIjlUNtbZWWqEBj9X3nMegiUNeG1Bc=
Date: Sat, 18 Apr 2026 00:59:53 -0700
To: mm-commits@vger.kernel.org,dyoung@redhat.com,ruirui.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-kdump-reviewer-email-address.patch removed from -mm tree
Message-Id: <20260418075956.CABC2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Dave's kdump reviewer email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-kdump-reviewer-email-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dave Young <ruirui.yang@linux.dev>
Subject: MAINTAINERS: update Dave's kdump reviewer email address
Date: Wed, 15 Apr 2026 11:29:26 +0800

Use my personal email address due to the Red Hat work will stop soon

Link: https://lore.kernel.org/ad8GFhh3SI1wb7IC@darkstar.users.ipa.redhat.com
Signed-off-by: Dave Young <ruirui.yang@linux.dev>
Acked-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-kdump-reviewer-email-address
+++ a/MAINTAINERS
@@ -13789,7 +13789,7 @@ M:	Baoquan He <bhe@redhat.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
-R:	Dave Young <dyoung@redhat.com>
+R:	Dave Young <ruirui.yang@linux.dev>
 L:	kexec@lists.infradead.org
 S:	Maintained
 W:	http://lse.sourceforge.net/kdump/
_

Patches currently in -mm which might be from ruirui.yang@linux.dev are


