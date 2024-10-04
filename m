Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A424644E
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008781; cv=none; b=F52HJwDyqAv+MWUmkkxw5xyAxOyVuU6NH2nvqHK9QI8tdk5EAaoO6vJkXJLry87x92ivQjXTbkec7k4OD2lSrlQIXYklWFjv7OH4uwQzRl5qv1RVH4zrWsqhZMzO3rMJXik+ZkQeQ0Jghlx+MI7ikR5o9te+blfrHtBoBbJePQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008781; c=relaxed/simple;
	bh=Qr+8B2iY9ej5ALf5+o7NSuT04yN4B7GF/yH5Yhj44Rg=;
	h=Date:To:From:Subject:Message-Id; b=KBPpkGNqyA4w50udM8aIQZKsG/zU/D7mkEHTHSTfSOtNQvMxwD/TJqDdZ/0Xm7mkItcCPC/XkscsGgj5dvUZehwOIONgqFDcEhYizfB7xKDsUAZLxtcLUmG1hTVKgO06Dg1VfDjjdPxPlJI0MCxMfOotwpV5KPIZyMKbZcZ4GBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkANwvyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkANwvyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE8C4CEC5;
	Fri,  4 Oct 2024 02:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008781;
	bh=Qr+8B2iY9ej5ALf5+o7NSuT04yN4B7GF/yH5Yhj44Rg=;
	h=Date:To:From:Subject:From;
	b=QkANwvyqfpalWSPQ68oH4ns/OI5wu15UWOrVYUkgtyKnpzBpmPPjuFHpFXL4TG5Ol
	 mTQBkv9oL+7ncVYO302S9gmYok+LYepuTCRqb+dTfk048mat41h+pJmjacfmzkODny
	 HtEujZ3uObCt5/BhizzlPupINZfKhieu10/pvdzU=
Date: Thu, 03 Oct 2024 19:26:20 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,i@maskray.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-fangruis-email.patch removed from -mm tree
Message-Id: <20241004022620.EBDE8C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: update Fangrui's email
has been removed from the -mm tree.  Its filename was
     mailmap-update-fangruis-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fangrui Song <i@maskray.me>
Subject: .mailmap: update Fangrui's email
Date: Fri, 27 Sep 2024 12:29:12 -0700

I'm leaving Google.

Link: https://lkml.kernel.org/r/20240927192912.31532-1-i@maskray.me
Signed-off-by: Fangrui Song <i@maskray.me>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-fangruis-email
+++ a/.mailmap
@@ -203,6 +203,7 @@ Ezequiel Garcia <ezequiel@vanguardiasur.
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason@jlekstrand.net>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason.ekstrand@intel.com>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason.ekstrand@collabora.com>
+Fangrui Song <i@maskray.me> <maskray@google.com>
 Felipe W Damasio <felipewd@terra.com.br>
 Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
_

Patches currently in -mm which might be from i@maskray.me are


