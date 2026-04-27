Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D431282C
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294499; cv=none; b=I9L5GU1lAypYWHSygjYGWVHtTzzCnCZv8Piek2Ig7idCA33eZyD1qq+OkS3Ydsd2yoa/gRT2ho0gwzN6T4mCp0PL1xwaCzX+RsIm/+OayriXrzMghInSf33OSDfuozmfEQqauLF4qsXaElOo2+bCNTr856FyVhchl5yQRwybtyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294499; c=relaxed/simple;
	bh=VMaqiE6QcAMX7pChHcVBAcMK5H4gBABmn1sU47MnJRs=;
	h=Date:To:From:Subject:Message-Id; b=qN4cEXQZK56dWZtN4J9CwA8CPdRr2+wqpQblimwngWXpAlnU36anig4hg/upIHtMJzmUPxDRtRC8E6lLrOJNXbb47djontirTMW7rCj+1CmXk6C6NL8JBgKCzqYbI8wgyaujh2Pk3StBNtH9r60b5wpZRVfzWk0oq7OqEKRGBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XrwEEkGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XrwEEkGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC02C19425;
	Mon, 27 Apr 2026 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294499;
	bh=VMaqiE6QcAMX7pChHcVBAcMK5H4gBABmn1sU47MnJRs=;
	h=Date:To:From:Subject:From;
	b=XrwEEkGkBTsJBoNOpRmMOLt+LslbFARm6/C0XUwozKyPOZc6OnlLudt5uXz//5eiu
	 KF8+u3sEdsOjHAXn2BEdJ1pGfI6jnRP/CMXGpnzTEPueud+W3UhnE8tw/8tYdZnpSV
	 4Foob3rmEd1g9MkkqhM729LZu90Xts69/sqZ+MHQ=
Date: Mon, 27 Apr 2026 05:54:58 -0700
To: mm-commits@vger.kernel.org,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-dan-carpenter.patch removed from -mm tree
Message-Id: <20260427125459.8BC02C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Dan Carpenter
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-dan-carpenter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <error27@gmail.com>
Subject: mailmap: update entry for Dan Carpenter
Date: Mon, 20 Apr 2026 18:15:50 +0300

Update my mailmap entry to point to my current email address.

Link: https://lore.kernel.org/ab2d502542c24491c191a76494717c340afb9a9b.1776691831.git.error27@gmail.com
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-dan-carpenter
+++ a/.mailmap
@@ -207,6 +207,7 @@ Claudiu Beznea <claudiu.beznea@tuxon.dev
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
+Dan Carpenter <error27@gmail.com> <dan.carpenter@linaro.org>
 Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
 Dan Williams <djbw@kernel.org> <dan.j.williams@intel.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
_

Patches currently in -mm which might be from error27@gmail.com are


