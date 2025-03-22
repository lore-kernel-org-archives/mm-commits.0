Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E527081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620255; cv=none; b=Hj2xB9OsrmsJXM9wIfEbtY5BQNaRgpHq2pFmdanEpwDw6yIOJL/E19sMdmZXO9RFKyYFjmxvHdno3gClHwaaV09yJ19yRd/w6TD1HNY4GYBO2Kdert1y635Gote57dv7ndRd+roQYeejA0bduEO9lzQ6ny6S4j+99NSLn925MDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620255; c=relaxed/simple;
	bh=cwdSNxYgVWC9hlfpvqvM82AjXTY+W0iNYBMLsS2xGhY=;
	h=Date:To:From:Subject:Message-Id; b=YDXx+BNtzJ5EJRRWkYnn1r4sX/nm4f2tloKiD5/bY5OqUk+qPHw0jGoRP0qOgTPHaBzPfb7KJ9tpp9k5Uz+GkmcP7EZmoJEPZCBZAnAGZN/9zKxNc7bkvEq6/MnS+vTeiYe5gxUoZRJp2bw/3b4QhIUkD3dQbqEtpsEWLMAImqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Dveo685; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Dveo685"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588CAC4CEDD;
	Sat, 22 Mar 2025 05:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620255;
	bh=cwdSNxYgVWC9hlfpvqvM82AjXTY+W0iNYBMLsS2xGhY=;
	h=Date:To:From:Subject:From;
	b=1Dveo685EIxtqiKi3fQjtleSyWHxgwvPUU+Ju2+gLYrKVBluoCWql3g24sRbUIRRB
	 uc1UbKQvGk5ivsPYMqJUOFpfWpBJaZL2+N26zYf+4jfrbYovtFduu8xaiY21YB3xCB
	 iVkltovj/oUCmMF3Xs17XKPSi2fZCc7o9WKBYtQY=
Date: Fri, 21 Mar 2025 22:10:54 -0700
To: mm-commits@vger.kernel.org,alexander.sverdlin@siemens.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch removed from -mm tree
Message-Id: <20250322051055.588CAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: consolidate email addresses of Alexander Sverdlin
has been removed from the -mm tree.  Its filename was
     mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Subject: mailmap: consolidate email addresses of Alexander Sverdlin
Date: Wed, 19 Mar 2025 09:52:46 +0100

Alias all the addresses used in the past and currently to the single
contact address.

Link: https://lkml.kernel.org/r/20250319085251.3335678-1-alexander.sverdlin@siemens.com
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/.mailmap~mailmap-consolidate-email-addresses-of-alexander-sverdlin
+++ a/.mailmap
@@ -31,6 +31,13 @@ Alexander Lobakin <alobakin@pm.me> <alob
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nsn.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@siemens.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@sysgo.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <subaparts@yandex.ru>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Avshalom Lazar <quic_ailizaro@quicinc.com> <ailizaro@codeaurora.org>
_

Patches currently in -mm which might be from alexander.sverdlin@siemens.com are


