Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF686287276
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 02:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086673; cv=none; b=gvLpTVynLh8m/6SoT+45bpyRsN5+b7wP2FVsW9Odu2g/rlPKj14SL6Kr5fH1UxvGN6qQwxbjVZau7eZzf3Z35kBlWnyBew0jLOqq38SavVMr7SCVL4Kstg2NKJSL+DjvP7/+fBsnrgZcyKT0Bhmyd3SdnW7frE77NEOo7wmdYYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086673; c=relaxed/simple;
	bh=X4PPikAJA81HxaxL02vY39wcsYVEr0CXB9kCp6AVjs8=;
	h=Date:To:From:Subject:Message-Id; b=ZMTn3j90cjqyJH3tknTa9+gjIoLFPe5JdpfH4ENK2R8Ll0SYSp1jhb8BySBc5n6e6zPKl1CJxCem/k+Rqv0NMk2khgV1BSoDSZCqfaw9MwjvNIGzjBw3fj1NOpXHl4PqiKDc1s5cl7pYnA6pAsIYvS580Dd1bEIc2fWO/n5Dgrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ueqIr5GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ueqIr5GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEADAC116C6;
	Tue,  3 Feb 2026 02:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086672;
	bh=X4PPikAJA81HxaxL02vY39wcsYVEr0CXB9kCp6AVjs8=;
	h=Date:To:From:Subject:From;
	b=ueqIr5GNSPN3wtc1VW+ZWHkjagqtfiaLs9dzEsKsI5XBAn0phmkRN98JSASm2PzUc
	 lvZVc0+GQdVW447r5A4YluZ/Xm/mzMwIMT5sMOl5x0C6bHDLsfmNZC6Xh3SN5C2LXb
	 3z/BqNPG7ISOP9njZZqvvU5t9dap8R1ndVPNFOFo=
Date: Mon, 02 Feb 2026 18:44:32 -0800
To: mm-commits@vger.kernel.org,aleksandr.mikhalitsyn@futurfusion.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-alexander-mikhalitsyns-emails.patch removed from -mm tree
Message-Id: <20260203024432.BEADAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Alexander Mikhalitsyn's emails
has been removed from the -mm tree.  Its filename was
     mailmap-update-alexander-mikhalitsyns-emails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: mailmap: update Alexander Mikhalitsyn's emails
Date: Wed, 28 Jan 2026 18:39:15 +0100

Link: https://lkml.kernel.org/r/20260128173915.162309-1-alexander@mihalicyn.com
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-alexander-mikhalitsyns-emails
+++ a/.mailmap
@@ -33,6 +33,7 @@ Alexander Lobakin <alobakin@pm.me> <alob
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@futurfusion.io>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
_

Patches currently in -mm which might be from aleksandr.mikhalitsyn@futurfusion.io are


