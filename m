Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE7D2773D0
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755635226; cv=none; b=ai+mMYC+7hYRiKlOLFZ2E/cumxenKw+/gg8OGSe9adm76M2Y5JxgeIzLiU2R3gsA0snldYA99A/gy542QG1LZrgGAyGVuGKBKsXBTkQX1i41VK6mddfHxqlnL0C71Xi5lefk6aQrWPZq5FZH+DLqlE32Sscgs5AatNGb7+S+FxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755635226; c=relaxed/simple;
	bh=nV1Tbnf4NklW/xk1oAmTjCICXIuCNvFHqLdlZZaUpjA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WbYt749bW4Qs5fuwvWWcl0dd48MSTDmnCuJmS9uaS4S7YSkkL5HgLPmiqv+ie18PWZ7/wtKRM61j+Y5IbBoJdSOR6A6dZCeVN9x4EyktRFgxenFFCvgTKhhbTtGadqajfAuJKE3QMTiTo9h3wUQrhzfYuZxwmCKr+OIJkjCXMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p66uD+lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p66uD+lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38036C4CEF1;
	Tue, 19 Aug 2025 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755635225;
	bh=nV1Tbnf4NklW/xk1oAmTjCICXIuCNvFHqLdlZZaUpjA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p66uD+lhfdwIoEe31+Y2DxwHYhZmb7JxJofCk8xl6xgzJtgpFKBC9OLCD8qP24W8q
	 GE8Do6xq7GANRMc2gmOZucL2oUwuBhGo42P48nk+fNVn+fq8boHc0EvBJjdVcfUfQ5
	 vGBnGbU/Cvn2Q2ch3FUGUNzpghs4T5WA4kXVB8c8=
Date: Tue, 19 Aug 2025 13:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Brauner <brauner@kernel.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, mjguzik@gmail.com,
 gaoxiang17@xiaomi.com, oleg@redhat.com
Subject: Re: + pid-change-task_state-to-use-task_ppid_nr_ns.patch added to
 mm-nonmm-unstable branch
Message-Id: <20250819132704.373f082b5721ba4b8e595811@linux-foundation.org>
In-Reply-To: <20250819-polster-aufkreuzen-fbe16c668b4e@brauner>
References: <20250812013445.046F8C4CEED@smtp.kernel.org>
	<20250819-polster-aufkreuzen-fbe16c668b4e@brauner>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Aug 2025 13:37:39 +0200 Christian Brauner <brauner@kernel.org> wrote:

> Andrew, would you please drop these four patches I'm taking them through
> the pid{fs} tree.
> 

Gone.
