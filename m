Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D149C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 22 Nov 2021 21:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhKVVra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Nov 2021 16:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhKVVr3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Nov 2021 16:47:29 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E37C061574
        for <mm-commits@vger.kernel.org>; Mon, 22 Nov 2021 13:44:22 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HyglQ4zYbz4xbC;
        Tue, 23 Nov 2021 08:44:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637617461;
        bh=jbqHcx8eXSx/O8fteGQIb1GEl8NrWzm3Tcb/dGqeowM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzlR9u0SSPpRbWs3b19WGJSrWm2GRyUYMxY6cIkp2kDvdiMtAFWS0x2fM+s/3SO8b
         c2XLr5sgNrmfTaxNTJgP7gFYVnrpnMOybTWB/prIfRN83FoGHt2MGYprwNc4HlIRZa
         QIjLHbJIVteRbAdyGM5REtMLMm8QFFiJshDYNNvdgo6n4FQVLV7aoTnp/r6I9Lmvnp
         ufodlL0AYMY4MkMH3VIO1Ir3uS+mpol1/uaW0Icwvn6iy+xapVKj9dsykh5J1owyau
         N40tmvZpmoerdD3jVrlQL1se8F0tVfNikeGWFJn8wHRxXzC+FXmXldqGCNgNeQaai0
         oU95wUoywSCpg==
Date:   Tue, 23 Nov 2021 08:44:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     christian@brauner.io, dhowells@redhat.com, hch@infradead.org,
        hdegoede@redhat.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: + proc-make-the-proc_create-stubs-static-inlines-fix.patch
 added to -mm tree
Message-ID: <20211123084417.50ece6ad@canb.auug.org.au>
In-Reply-To: <20211119010422.ZzUvO1GaL%akpm@linux-foundation.org>
References: <20211119010422.ZzUvO1GaL%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YN6138fIRGQ+xbWpj3gaL3O";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/YN6138fIRGQ+xbWpj3gaL3O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 18 Nov 2021 17:04:22 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: proc-make-the-proc_create-stubs-static-inlines-fix
> has been added to the -mm tree.  Its filename is
>      proc-make-the-proc_create-stubs-static-inlines-fix.patch

Added to linux-net today.

--=20
Cheers,
Stephen Rothwell

--Sig_/YN6138fIRGQ+xbWpj3gaL3O
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGcDzEACgkQAVBC80lX
0GwEbwf/XLHyn8I/pkopIIUNZU5D0D66yqt9igPpSeW37EGl3oJWul1S6jLv865l
oRh4zDKB29U0g/E8Q+gUlQZ1kv+QTcxrCEoHHR50ASVRf/kLDCepP94/BVOzRKxf
JG6tcdISKPA2oS492e/bYqZHo6SCkfd7zmYNb00eNaI9pbj4NQzaem/wwrVn6VxM
baKbo5F5TeLbZK8Icdm7k4mujzp9HvEnbIzExBv7b0RXati9+ditOK1fPznHegQw
lgwjpDi3tMvbWQ3qj8rdol2MPusFJBt8+EEBX9oUzGzP+IOl06X1EO+OUA+A49pq
ggvWv8+Fdf8OJId/AwMnK0WyqCirGg==
=KcMi
-----END PGP SIGNATURE-----

--Sig_/YN6138fIRGQ+xbWpj3gaL3O--
