Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B85C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 00:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA2322464
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 00:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="aYKnTlpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgKBAG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 19:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgKBAG1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Nov 2020 19:06:27 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436E6C0617A6
        for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2020 16:06:26 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CPY9R2s5vz9sS8;
        Mon,  2 Nov 2020 11:06:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604275583;
        bh=empTlbGg0+ySJYiINfvzeude2e1VEEgnZQAS/E0z+To=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aYKnTlpEhSxRaHGtsZZeiMg8HrlvtdEpkry1lKVzpW5TdsqE5YMtskduedJnhuZ1L
         01eR4ZcB6i53CnpXoDOClBZ6tYgOmUTJBiJCBsPtApFiqBrAasm2IQzHVrztvBCp6x
         AlZuwpPRi66/MdhKoQ4fW14w5DqNNsMB2gB/WGpEYX7nQ0Z54RGi2NKko0YDKsg0wI
         5bFggYJJSOan94q/Q47G1sA2+uMEXFeCp9Ryx1aXClNqSEQ5BGzQ/owldt8gXntifZ
         wWO9rLbtLxdCbqERQj4oAQvqsiChUuJr1WvCtXCiJNotAAkTM8FI7wFWcYMbXdUaT/
         A89sYiL34mOYg==
Date:   Mon, 2 Nov 2020 11:06:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, dhowells@redhat.com, ink@jurassic.park.msu.ru,
        lkp@intel.com, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rth@twiddle.net, willy@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: + compilerh-fix-barrier_data-on-clang-fix.patch added to -mm
 tree
Message-ID: <20201102110616.5a0c8aff@canb.auug.org.au>
In-Reply-To: <20201101234441.FjZjSdCQ5%akpm@linux-foundation.org>
References: <20201101234441.FjZjSdCQ5%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0yuGR6nj5_fejoCJHII_E9y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/0yuGR6nj5_fejoCJHII_E9y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 01 Nov 2020 15:44:41 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: asm-generic: barrier.h: fix ALPHA builds when SMP is not en=
abled
> has been added to the -mm tree.  Its filename is
>      compilerh-fix-barrier_data-on-clang-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/0yuGR6nj5_fejoCJHII_E9y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+fTXgACgkQAVBC80lX
0GzvOQf/ZJ+vqtj7P/CGagutIyI1mgqJ+4UzkQW5Vi57B12kyCbTKQIIl6qxqRJd
xNuuaymYJv9PGk7WiASWMSR/0vre6vgt/qUsMYY7gqQZevHsT2DvPQ9OoS8pIcp/
NsOpiCk6sDa4cTcUYsfDMjG0/NdZJoNbGjOXZU9uNagOvMf1wBb9qkC2AoLMaJ2W
rzIJs000vhky7jRZdZJ6zBPcGQ7mFrnBKudtDhYVpOHkm5akImuqC1bDNGGLg/3A
dp6DpCOqafY8FPWRm7Wy/FbZniZtV68psaBlVdbXglf4pBk2Ty2iWMuBurqAcYlR
GfnbUvcxxZBdo7aXusTf4XkfL5GFjw==
=Ddcg
-----END PGP SIGNATURE-----

--Sig_/0yuGR6nj5_fejoCJHII_E9y--
